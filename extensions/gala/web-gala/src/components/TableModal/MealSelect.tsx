import { faCaretDown } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { Listbox, Transition } from "@headlessui/react";
import { Fragment } from "react";

type MealSelectProps = {
  selected: string;
  setSelected: React.Dispatch<React.SetStateAction<string>>;
  className?: string;
  style?: React.CSSProperties;
};

const optionMap = new Map<string, string>([
  ["NOR", "Carne"],
  ["VEG", "Vegetariano"],
]);

export default function MealSelect({
  selected,
  setSelected,
  className,
  style,
}: MealSelectProps) {
  return (
    <div className={`relative ${className}`} style={style}>
      <Listbox value={selected} onChange={setSelected}>
        <Listbox.Button className="flex w-full items-center rounded-3xl bg-light-gold px-3 py-2 text-start">
          {optionMap.get(selected)}
          <FontAwesomeIcon className="ml-auto" icon={faCaretDown} />
        </Listbox.Button>
        {/* [&>*] is the selector for all direct children */}
        <Transition
          as={Fragment}
          enter="transition ease-out duration-100"
          enterFrom="opacity-0"
          enterTo="opacity-100"
          leave="transition ease-in duration-100"
          leaveFrom="opacity-100"
          leaveTo="opacity-0"
        >
          <Listbox.Options className="absolute top-full w-full border border-black bg-base-100 [&>*]:cursor-pointer">
            <Listbox.Option value="NOR">{optionMap.get("NOR")}</Listbox.Option>
            <Listbox.Option value="VEG">{optionMap.get("VEG")}</Listbox.Option>
          </Listbox.Options>
        </Transition>
      </Listbox>
    </div>
  );
}

MealSelect.defaultProps = {
  className: "",
  style: {},
};
