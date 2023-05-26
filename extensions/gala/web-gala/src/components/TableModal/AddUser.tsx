import { useState } from "react";
import Input from "../Input";
import MealSelect from "./MealSelect";
import Avatar from "../Avatar";

export default function AddUser() {
  const [selected, setSelected] = useState("NOR");
  const grid = {
    display: "grid",
    gridTemplateAreas: "'icon0 input0' 'icon1 input1'",
    alignItems: "center",
  };
  const icon0 = {
    gridArea: "icon0",
  };
  const input0 = {
    gridArea: "input0",
  };
  const icon1 = {
    gridArea: "icon1",
  };
  const input1 = {
    gridArea: "input1",
  };

  return (
    <div className="grid gap-2" style={grid}>
      <Avatar style={icon0} />
      <MealSelect
        selected={selected}
        setSelected={setSelected}
        style={input0}
      />
      <Input
        className="px-3 py-2"
        placeholder="Alergias (se aplicável)"
        style={input1}
      />
    </div>
  );
}
