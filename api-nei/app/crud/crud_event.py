from dataclasses import dataclass
from typing import List, Optional, Tuple

from sqlalchemy.orm import Session

from app.crud import user as crud_user
from app.models.user import User
from app.crud.base import CRUDBase
from app.models.event import Event
from app.models.user.user_email import UserEmail
from app.schemas.user.user import UserCreateForEvent
from app.schemas.event import CreateEvent, UpdateEvent


@dataclass
class ImportUsersSuccess:
    event: Event
    created_users: List[Tuple[User, UserEmail]]


class CRUDEvent(CRUDBase[Event, CreateEvent, UpdateEvent]):
    def import_users(
        self, db: Session, *, id: int, users: List[UserCreateForEvent]
    ) -> Optional[ImportUsersSuccess]:
        """
        Creates users for an event, returning the created users.

        Users that already existed aren't associated with the event and aren't
        returned, but they have their scopes updated.
        """
        with db.begin_nested():
            event = self.get(db, id=id, for_update=True)

            if event is None:
                return None

            created_users = []

            participant_scope = f"participant:{id}"

            for user in users:
                maybe_user_model = crud_user.get_by_email(
                    db, user.email, for_update=True
                )

                if maybe_user_model is None:
                    user_model = User(
                        for_event=event.id,
                        scopes=[participant_scope],
                        **user.dict(exclude={"email"}, exclude_unset=True),
                    )
                    db.add(user_model)
                    db.flush()
                    db.refresh(user_model)

                    email_model = UserEmail(
                        user_id=user_model.id, active=False, email=user.email
                    )
                    db.add(email_model)

                    created_users.append((user_model, email_model))
                else:
                    user_model = maybe_user_model[0]
                    if participant_scope not in user_model.scopes:
                        user_model.scopes.append(participant_scope)

            db.commit()

        return ImportUsersSuccess(event=event, created_users=created_users)


event = CRUDEvent(Event)
