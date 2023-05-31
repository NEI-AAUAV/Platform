import { useState } from "react";
import Input from "../../Input";
import MealSelect from "./MealSelect";
import Avatar from "../../Avatar";

type AddUserProps = {
  btn?: { icon: JSX.Element; onClick: () => void };
  isAuth?: boolean;
  className?: string;
};

export default function AddUser({ btn, isAuth, className }: AddUserProps) {
  const icon = btn?.icon;
  const onClick = btn?.onClick;
  const [selected, setSelected] = useState("NOR");

  const grid = {
    gridTemplateColumns: `2.5rem 1fr`,
  };

  return (
    <div
      className={`grid items-center justify-items-center gap-2 ${className}`}
      style={grid}
    >
      <Avatar isAuth={isAuth} />
      <MealSelect selected={selected} setSelected={setSelected} />
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
      <Input className="px-3 py-2" placeholder="Alergias (se aplicável)" />
    </div>
  );
}

AddUser.defaultProps = {
  btn: { icon: undefined, onClick: () => {} },
  className: "",
  isAuth: true,
};
