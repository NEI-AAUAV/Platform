import { useFormContext } from "react-hook-form";
import { faGraduationCap, faTrash } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Option from "./Option";

export type Props = {
  vote: Vote;
};

export default function VoteCard({ vote }: Props) {
  const { setValue } = useFormContext();

  return (
    <div className="flex flex-col gap-4 rounded-xl p-4 border border-dark-gold bg-black/20 backdrop-blur-md">
      <div id="header" className="flex flex-row items-center gap-3 text-base-200">
        <div id="title" className="flex-1 text-center">
          <h2 className="text-sm font-light text-neutral-400 font-gala">O mais...</h2>
          <h1 className="text-2xl font-semibold font-gala">{vote.category}</h1>
        </div>
      </div>

      <div id="options" className="flex flex-col gap-4">
        {vote.options.map((option, i) => {
          return (
            <Option
              key={i}
              name={option}
              optionIdx={i}
              disabled={vote.already_voted !== null}
              catId={vote._id}
            />
          );
        })}
      </div>
    </div>
  );
}
