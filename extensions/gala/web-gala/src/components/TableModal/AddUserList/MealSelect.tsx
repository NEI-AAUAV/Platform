import { faCaretDown } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Select from "@/components/Select";

type MealSelectProps = {
  selected: "NOR" | "VEG";
  setSelected: React.Dispatch<React.SetStateAction<"NOR" | "VEG">>;
  className?: string;
  style?: React.CSSProperties;
  onChange: (e: "NOR" | "VEG") => void;
};

const optionMap = new Map<string, JSX.Element>([
  ["NOR", <>Carne</>],
  ["VEG", <>Vegetariano</>],
]);

export default function MealSelect({
  onChange,
  selected,
  setSelected,
  className,
  style,
}: MealSelectProps) {
  const options: [JSX.Element, "NOR" | "VEG"][] = [
    [optionMap.get("NOR") ?? <>Error</>, "NOR"],
    [optionMap.get("VEG") ?? <>Error</>, "VEG"],
  ];
  return (
    <div className={`relative w-full ${className}`} style={style}>
      <Select
        selected={selected}
        setSelected={setSelected}
        onChange={onChange}
        title={
          <>
            {optionMap.get(selected)}
            <FontAwesomeIcon
              className="ml-auto ui-open:rotate-180"
              icon={faCaretDown}
            />
          </>
        }
        options={options}
      />
    </div>
  );
}

MealSelect.defaultProps = {
  className: "",
  style: {},
};
