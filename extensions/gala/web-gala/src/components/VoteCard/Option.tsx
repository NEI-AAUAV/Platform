import classNames from "classnames";
import { useFormContext, useWatch } from "react-hook-form";

type OptionProps = {
  name: string;
  surname: string;
  disabled?: boolean;
  optionIdx?: number;
  catId?: number;
};

export default function Option({
  name,
  surname,
  optionIdx,
  disabled,
  catId,
}: OptionProps) {
  const { setValue } = useFormContext();
  const currentSelected = useWatch({
    name: `votes.${catId}.option`,
  });

  return (
    <button
      type="button"
      disabled={disabled}
      className={classNames(
        "flex flex-row items-center gap-2 rounded-lg border border-[#EBD5B5] p-2 shadow-[0_2px_6px_0px_rgba(182,160,128,0.25)]",
        {
          "bg-gradient-to-r from-[#EBD5B5] to-[#B6A080]":
            currentSelected === optionIdx,
        },
      )}
      onClick={() => {
        setValue(`votes.${catId}.option`, optionIdx);
      }}
    >
      <span className="font-semibold">{name}</span> {surname}
    </button>
  );
}

Option.defaultProps = {
  disabled: false,
};
