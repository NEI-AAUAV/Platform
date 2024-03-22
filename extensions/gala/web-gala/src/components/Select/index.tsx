import { Listbox, Transition } from "@headlessui/react";
import classNames from "classnames";
import { Fragment } from "react";

type SelectProps<T> = {
  selected: T;
  setSelected: React.Dispatch<React.SetStateAction<T>>;
  title: JSX.Element;
  options: [JSX.Element, T][];
  className?: string;
  onChange: (e: T) => void;
  disabled?: boolean;
};
export default function Select<T>({
  onChange,
  selected,
  setSelected,
  title,
  options,
  className,
  disabled,
}: SelectProps<T>) {
  return (
    <div className={`relative w-full ${className}`}>
      <Listbox
        value={selected}
        onChange={(e) => {
          setSelected(e);
          onChange(e);
        }}
      >
        <Listbox.Button
          className={classNames(
            "flex w-full items-center rounded-3xl bg-light-gold px-3 py-2 text-start !text-inherit hover:saturate-150",
            { "btn-disabled": disabled },
          )}
        >
          {title}
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
          <Listbox.Options className="absolute top-full z-10 mt-2 w-full overflow-visible rounded-2xl border border-light-gold bg-base-100 shadow-[0_4px_16px_rgba(0,_0,_0,_0.25)] [&>*]:cursor-pointer">
            {options.map(([option, value], i) => {
              const isLast = i === options.length - 1;
              return (
                <Listbox.Option
                  key={String(value)}
                  className={classNames(
                    "flex items-center px-3 py-2 text-start",
                    {
                      "border-b border-light-gold": !isLast,
                    },
                  )}
                  value={value}
                >
                  <div>{option}</div>
                  <div
                    className={classNames(
                      "ml-auto aspect-square w-3 rounded-full border-2 border-base-100 shadow-[0_0_0_1px_black]",
                      {
                        "bg-black": selected === value,
                      },
                    )}
                  />
                </Listbox.Option>
              );
            })}
          </Listbox.Options>
        </Transition>
      </Listbox>
    </div>
  );
}

Select.defaultProps = {
  className: "",
};
