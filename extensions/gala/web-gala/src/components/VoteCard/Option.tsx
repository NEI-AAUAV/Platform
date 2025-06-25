import classNames from "classnames";
import { useFormContext, useWatch } from "react-hook-form";
import data from "./data.ts";
import config from "@/config";

type OptionProps = {
  name: string;
  disabled?: boolean;
  optionIdx?: number;
  catId?: number;
};

console.log(data);
export default function Option({ name, optionIdx, disabled, catId }: OptionProps) {
  const { setValue } = useFormContext();
  const currentSelected = useWatch({
    name: `votes.${catId}.option`,
  });

  return (
    <button
      type="button"
      disabled={disabled}
      className={classNames(
        "flex flex-row items-center gap-2 rounded-full border p-2 transition-colors duration-300 ease-in-out",
        {
          "bg-gradient-to-r from-[#F7BBAC] to-[#C58676] border-transparent": currentSelected === optionIdx, // Selected state
          "bg-black/20 border-dark-gold": currentSelected !== optionIdx, // Default state
        },
      )}
      onClick={() => {
        setValue(`votes.${catId}.option`, optionIdx);
      }}
    >
      {catId && (
        <img
          src={`${config.BASE_URL}/gala/categories/${data[`c${catId}`][name]}`}
          alt={name}
          className="inline-block w-8 h-8 rounded-full object-cover object-center"
        />
      )}
      <span
        className={classNames(
          "text-left font-gala font-semibold transition-all duration-300 ease-in-out bg-clip-text ",
          {
            "text-black": currentSelected === optionIdx, // Gradient text when selected
            "text-transparent bg-gradient-to-r from-[#F7BBAC] to-[#C58676]": currentSelected !== optionIdx, // Default text color
          },
        )}>
        {name}
      </span>
    </button>
  );
}

Option.defaultProps = {
  disabled: false,
  optionIdx: 0,
  catId: 0,
};
