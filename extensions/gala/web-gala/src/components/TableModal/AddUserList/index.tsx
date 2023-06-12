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
  const { control, setValue } = useFormContext();
  const { fields, append, remove } = useFieldArray({
    control,
    name: "companions",
  });

  return (
    <div className={`relative flex max-h-64 flex-col gap-3 ${className}`}>
      <AddUser
        setDish={(dish) => setValue(`dish`, dish)}
        setAllergies={(allergies) => setValue(`allergies`, allergies)}
      />
      {fields.map((field, index) => (
        <AddUser
          key={field.id}
          id={-1}
          setDish={(dish) => setValue(`companions.${index}.dish`, dish)}
          setAllergies={(allergies) =>
            setValue(`companions.${index}.allergies`, allergies)
          }
          btn={{
            icon: <FontAwesomeIcon icon={faTrash} />,
            onClick: () => remove(index),
          }}
        />
      ))}
      <button
        className="sticky bottom-0 mt-2 bg-base-100 p-2 disabled:text-base-content/10"
        type="button"
        disabled={fields.length >= freeSeats - 1}
        onClick={() => {
          if (fields.length >= freeSeats - 1) return;
          append({
            dish: "NOR",
            allergies: "",
          });
        }}
      >
        <FontAwesomeIcon icon={faPlus} /> Adicionar acompanhante
      </button>
    </div>
  );
}

AddUserList.defaultProps = {
  className: "",
};
