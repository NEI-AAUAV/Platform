from fastapi import HTTPException
from app.schemas.team import AdminCheckPointSelect
from app.schemas.user import DetailedUser


def get_checkpoint_id(user: DetailedUser, form: AdminCheckPointSelect) -> int:
    checkpoint_id = form.checkpoint_id

    if checkpoint_id is None:
        if user.staff_checkpoint_id is None:
            raise HTTPException(
                status_code=400, detail="Admin doesn't have a default checkpoint"
            )
        checkpoint_id = user.staff_checkpoint_id
    elif not user.is_admin and checkpoint_id != user.staff_checkpoint_id:
        raise HTTPException(
            status_code=401, detail="Only admins can specify the checkpoint"
        )

    return checkpoint_id
