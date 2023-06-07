import { useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useFieldArray, useFormContext } from "react-hook-form";
import { faPlus, faTrash } from "@fortawesome/free-solid-svg-icons";
import AddUser from "./AddUser";

type AddUserListProps = {
  freeSeats: number;
  className?: string;
};

export default function AddUserList({
  freeSeats,
  className,
}: AddUserListProps) {
  const [users, setUsers] = useState<{ id: string }[]>([]);

  const { control, setValue } = useFormContext();
  const { fields, append, remove, update } = useFieldArray({
    control,
    name: "companions",
  });

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
    <div className={`relative flex max-h-56 flex-col gap-3 ${className}`}>
      <AddUser
        control={control}
        setValue={(dish, allergies) => {
          setValue("dish", dish);
          setValue("allergies", allergies);
        }}
      />
      {fields.map((field, index) => (
        <AddUser
          key={field.id}
          id={-1}
          control={control}
          setValue={(dish, allergies) => {
            setValue(`companions.${index}.dish`, dish);
            setValue(`companions.${index}.allergies`, allergies);
          }}
          btn={{
            icon: <FontAwesomeIcon icon={faTrash} />,
            onClick: () => remove(index),
          }}
        />
      ))}
      <button
        className="sticky bottom-0 mt-2 bg-base-100 p-2 "
        type="button"
        onClick={() =>
          append({
            dish: "NOR",
            allergies: "",
          })
        }
      >
        <FontAwesomeIcon icon={faPlus} /> Adicionar acompanhante
      </button>
    </div>
  );
}

AddUserList.defaultProps = {
  className: "",
};
