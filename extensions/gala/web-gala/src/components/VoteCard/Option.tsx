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
        "flex flex-row items-center gap-6 rounded-lg border border-[#EBD5B5] p-2 shadow-[0_2px_6px_0px_rgba(182,160,128,0.25)]",
        {
          "bg-gradient-to-r from-[#EBD5B5] to-[#B6A080]":
            currentSelected === optionIdx,
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
          className="inline-block aspect-square w-16 rounded-lg object-cover object-center"
        />
      )}
      <span className="text-left font-semibold">{name}</span>
    </button>
  );
}

Option.defaultProps = {
  disabled: false,
  optionIdx: 0,
  catId: 0,
};
