import classNames from "classnames";
import Avatar from "../Avatar";

type OptionProps = {
  name: string;
  surname: string;
  selected?: boolean;
};

export default function Option({ name, surname, selected }: OptionProps) {
  return (
    <div
      className={classNames(
        "flex flex-row items-center gap-2 rounded-lg border border-[#EBD5B5] p-2 shadow-[0_2px_6px_0px_rgba(182,160,128,0.25)]",
        {
          "bg-gradient-to-r from-[#EBD5B5] to-[#B6A080]": selected,
        },
      )}
    >
      <Avatar id={null} className="w-[16px] flex-initial" />
      <p>
        <span className="font-semibold">{name}</span> {surname}
      </p>
    </div>
  );
}

Option.defaultProps = {
  selected: false,
};
