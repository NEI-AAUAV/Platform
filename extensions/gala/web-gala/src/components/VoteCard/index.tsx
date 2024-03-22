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
    <div className="flex flex-col gap-4 rounded-xl p-4 shadow-[0_4px_12px_0px_rgba(182,160,128,0.5)]">
      <div id="header" className="flex flex-row items-center gap-3">
        <FontAwesomeIcon
          icon={faGraduationCap}
          size="xl"
          className="flex-initial"
        />
        <div id="title" className="flex-1">
          <h2 className="text-sm font-light uppercase">O mais...</h2>
          <h1 className="text-xl font-semibold">{vote.category}</h1>
        </div>
        {vote.already_voted === null && (
          <button
            type="button"
            onClick={() => {
              setValue(`votes.${vote._id}.option`, undefined);
            }}
          >
            <FontAwesomeIcon icon={faTrash} />
          </button>
        )}
        {vote.already_voted !== null && (
          <div className="flex flex-col gap-2">
            <span className="text-sm font-light uppercase">Votado</span>
          </div>
        )}
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
