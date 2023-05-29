import { faCaretDown } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { Listbox, Transition } from "@headlessui/react";
import { Fragment, useRef } from "react";

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
    <div className={`relative w-full ${className}`} style={style}>
      <Listbox value={selected} onChange={setSelected}>
        <Listbox.Button className="flex w-full items-center rounded-3xl bg-light-gold px-3 py-2 text-start">
          {optionMap.get(selected)}
          <FontAwesomeIcon
            className="ui-open:rotate-180 ml-auto"
            icon={faCaretDown}
          />
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
          <Listbox.Options className="absolute top-full z-10 mt-2 w-full overflow-visible rounded-lg border border-light-gold bg-base-100 shadow-[0_4px_16px_rgba(0,_0,_0,_0.25)] [&>*]:cursor-pointer">
            <Listbox.Option
              className="border-b border-light-gold px-3 py-2"
              value="NOR"
            >
              {optionMap.get("NOR")}
            </Listbox.Option>
            <Listbox.Option className="px-3 py-2" value="VEG">
              {optionMap.get("VEG")}
            </Listbox.Option>
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
