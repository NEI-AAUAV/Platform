import {
  faCheck,
  faHandDots,
  faSeedling,
  faXmark,
} from "@fortawesome/free-solid-svg-icons";
import { Fragment, useRef } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Avatar from "@/components/Avatar";
import useNEIUser from "@/hooks/useNEIUser";
import useTableConfirm from "@/hooks/tableHooks/useTableConfirm";
import useTableUserRemove from "@/hooks/tableHooks/useTableUserRemove";
import { FrangoIcon } from "@/assets/icons";

type RequesterProps = {
  person: Person;
  tableId: number;
  mutate: () => void;
};

const orange = { color: "#DD8500" };
const green = { color: "#198754" };
const red = { color: "#DC3545" };
const iconMap = new Map([
  ["NOR", <FrangoIcon style={orange} />],
  ["VEG", <FontAwesomeIcon icon={faSeedling} style={green} />],
]);

function allergyIcon(allergies: string) {
  return (
    allergies.length > 0 && <FontAwesomeIcon icon={faHandDots} style={red} />
  );
}

const gridTemplate = {
  gridTemplateColumns: "max-content 1fr",
};

export default function Requester({ person, tableId, mutate }: RequesterProps) {
  const { neiUser } = useNEIUser(person.id);
  const rejectConfirmModalRef = useRef<HTMLDialogElement>(null);
  async function acceptGuest(userId: number) {
    await useTableConfirm(tableId, { uid: userId, confirm: true });
  }

  function modalRejectConfirm() {
    rejectConfirmModalRef.current!.showModal();
  }

  async function rejectGuest(userId: number) {
    await useTableUserRemove(tableId, userId);
  }
  return (
    <>
      <div className="grid items-center gap-1" style={gridTemplate}>
        {/* <Guest id={person.id} /> */}
        <div className="flex items-center gap-1">
          <button
            type="button"
            className="flex aspect-square w-6 items-center justify-center rounded-full bg-light-gold"
            onClick={async () => {
              await acceptGuest(person.id);
              mutate();
            }}
          >
            <FontAwesomeIcon icon={faCheck} />
          </button>
          <button
            className="flex aspect-square w-6 items-center justify-center rounded-full bg-light-gold"
            type="button"
            onClick={() => modalRejectConfirm()}
          >
            <FontAwesomeIcon icon={faXmark} />
          </button>
          <Avatar id={person.id} className="w-8" />
        </div>
        <div className="flex items-center gap-1">
          <span>{`${neiUser?.name} ${neiUser?.surname}`}</span>
          <span className="flex gap-1">
            {iconMap.get(person.dish)}
            {allergyIcon(person.allergies)}
          </span>
        </div>
        <div />
        <div className="flex items-center gap-1">
          <span className="font-light">
            {person.companions.length > 0 &&
              `+${person.companions.length} companions`}
          </span>
          <span className="flex gap-1">
            {person.companions.map((companion, idx) => (
              <Fragment key={idx}>
                {iconMap.get(companion.dish)}
                {allergyIcon(companion.allergies)}
              </Fragment>
            ))}
          </span>
        </div>
      </div>
      <dialog
        className="overflow-hidden rounded-3xl p-0 backdrop:bg-black backdrop:opacity-50"
        ref={rejectConfirmModalRef}
      >
        <h2 className="border-b border-black/20 p-4">Are you sure?</h2>
        <div className="grid grid-cols-2">
          <button
            type="button"
            className="border-r border-black/20 p-4 "
            onClick={async () => {
              rejectConfirmModalRef.current!.close();
              await rejectGuest(person.id);
              mutate();
            }}
          >
            Yes
          </button>
          <button
            type="button"
            className="p-4"
            onClick={() => rejectConfirmModalRef.current!.close()}
          >
            No
          </button>
        </div>
      </dialog>
    </>
  );
}