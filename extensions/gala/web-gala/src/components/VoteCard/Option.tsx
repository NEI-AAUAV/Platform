import classNames from "classnames";
import { UseFormGetValues, UseFormSetValue } from "react-hook-form";

type OptionProps = {
  name: string;
  surname: string;
  hasVoted: boolean;
  setValue?: UseFormSetValue<any>;
  getValues?: UseFormGetValues<any>;
  optionIdx?: number;
  catId?: number;
};

export default function Option({
  name,
  surname,
  hasVoted,
  setValue,
  getValues,
  optionIdx,
  catId,
}: OptionProps) {
  return (
    <button
      type="button"
      disabled={hasVoted}
      className={classNames(
        "flex flex-row items-center gap-2 rounded-lg border border-[#EBD5B5] p-2 shadow-[0_2px_6px_0px_rgba(182,160,128,0.25)]",
        {
          "bg-gradient-to-r from-[#EBD5B5] to-[#B6A080]":
            getValues && getValues(`votes.${catId}.option`) === `${optionIdx}`,
        },
      )}
      onClick={() => {
        if (setValue && getValues) {
          setValue(`votes.${catId}.option`, `${optionIdx}`);
        }
      }}
    >
      <span className="font-semibold">{name}</span> {surname}
    </button>
  );
}

Option.defaultProps = {
  setValue: () => {},
  getValues: () => {},
  optionIdx: 0,
  catId: 0,
};
