import { faGraduationCap, faTrash } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Option from "./Option";

export type Props = {
  vote: Vote;
};

export default function VoteCard(props: Props) {
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
          <h1 className="text-xl font-semibold">{props.vote.category}</h1>
        </div>
        <FontAwesomeIcon icon={faTrash} />
      </div>

      <div id="options" className="flex flex-col gap-4">
        {props.vote.options.map((option, i) => {
          const parts = option.split(/\s+/);

          const name = parts.length !== 0 ? parts[0] : "";
          const surname = parts.length !== 0 ? parts[parts.length - 1] : "";

          return <Option name={name} surname={surname} selected={i === 0} />;
        })}
      </div>
    </div>
  );
}
