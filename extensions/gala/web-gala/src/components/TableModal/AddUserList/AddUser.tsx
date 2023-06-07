import { Controller, SubmitHandler, useForm } from "react-hook-form";
import { forwardRef, useState } from "react";
import Input from "../../Input";
import MealSelect from "./MealSelect";
import Avatar from "../../Avatar";

type AddUserProps = {
  btn?: { icon?: JSX.Element; onClick: () => void };
  id?: number | null;
  control: any;
  className?: string;
  setValue: (dish: string, allergies: string) => void;
};

const AddUser = forwardRef(
  (
    { btn, id, className, control, setValue }: AddUserProps,
    ref: React.ForwardedRef<HTMLDivElement>,
  ) => {
    const icon = btn?.icon;
    const onClick = btn?.onClick;
    const [selected, setSelected] = useState("NOR");
    const { register, handleSubmit } = useForm<{
      dish: "NOR" | "VEG";
      allergies: string;
    }>();

    const grid = {
      gridTemplateColumns: `2.5rem 1fr`,
    };

    const updateValues: SubmitHandler<{
      dish: "NOR" | "VEG";
      allergies: string;
    }> = (data: any) => {
      setValue(selected, data.allergies);
    };

    return (
      <div
        className={`grid items-center justify-start gap-2 ${className}`}
        style={grid}
        ref={ref}
      >
        <Avatar id={id} />
        <Controller
          name="dish"
          defaultValue={selected}
          control={control}
          render={({ field: { onChange, name } }) => (
            <MealSelect
              onChange={(e) => {
                onChange({ target: { name, value: selected } });
                handleSubmit(updateValues)();
              }}
              name={name}
              selected={selected}
              setSelected={setSelected}
            />
          )}
        />

        <button
          className={`${
            icon === undefined
              ? "pointer-events-none invisible cursor-default"
              : ""
          }`}
          type="button"
          onClick={onClick}
        >
          {icon}
        </button>
        <Input
          className="px-3 py-2"
          placeholder="Alergias (se aplicável)"
          onInput={handleSubmit(updateValues)}
          {...register("allergies")}
        />
      </div>
    );
  },
);

AddUser.defaultProps = {
  btn: { icon: undefined, onClick: () => {} },
  className: "",
  id: null,
};

export default AddUser;

// export default function AddUser({ btn, id, className }: AddUserProps) {
//   const icon = btn?.icon;
//   const onClick = btn?.onClick;
//   const [selected, setSelected] = useState("NOR");
//   const { control, register } = useFormContext();

//   const grid = {
//     gridTemplateColumns: `2.5rem 1fr`,
//   };

//   return (
//     <div
//       className={`grid items-center justify-start gap-2 ${className}`}
//       style={grid}
//     >
//       <Avatar id={id} />
//       <Controller
//         name="dish"
//         defaultValue={selected}
//         control={control}
//         render={({ field: { onChange, name } }) => (
//           <MealSelect
//             onChange={(e) => onChange({ target: { name, value: selected } })}
//             name={name}
//             selected={selected}
//             setSelected={setSelected}
//           />
//         )}
//       />

//       <button
//         className={`${
//           icon === undefined
//             ? "pointer-events-none invisible cursor-default"
//             : ""
//         }`}
//         type="button"
//         onClick={onClick}
//       >
//         {icon}
//       </button>
//       <Input
//         className="px-3 py-2"
//         placeholder="Alergias (se aplicável)"
//         {...register("allergies")}
//       />
//     </div>
//   );
// }

// AddUser.defaultProps = {
//   btn: { icon: undefined, onClick: () => {} },
//   className: "",
//   id: null,
// };
