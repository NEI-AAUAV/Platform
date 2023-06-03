import { useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPlus, faTrash } from "@fortawesome/free-solid-svg-icons";
import AddUser from "./AddUser";

type AddUserListProps = {
  freeSeats: number;
};

export default function AddUserList({ freeSeats }: AddUserListProps) {
  const [users, setUsers] = useState<{ id: string }[]>([]);

  const handleRemove = (index: number) => {
    setUsers(users.filter((_, i) => i !== index));
  };

  const handleAdd = () => {
    if (users.length >= freeSeats - 1) return;
    const newUser = {
      id: Math.random().toString(),
    };
    setUsers([...users, newUser]);
  };

  return (
    <div className="relative flex max-h-56 flex-col gap-3 px-3">
      <AddUser className="snap-start scroll-mt-2" />
      {users.map((user, index) => (
        <AddUser
          key={user.id}
          className="snap-start scroll-mt-2"
          btn={{
            icon: <FontAwesomeIcon icon={faTrash} />,
            onClick: () => handleRemove(index),
          }}
        />
      ))}
      <button
        className="sticky bottom-0 mt-2 bg-base-100 p-2 "
        type="button"
        onClick={handleAdd}
      >
        <FontAwesomeIcon icon={faPlus} /> Adicionar acompanhante
      </button>
    </div>
  );
}
