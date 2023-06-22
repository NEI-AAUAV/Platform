import { faGraduationCap, faTrash } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Option from "./Option";

export default function VoteCard() {
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
          <h1 className="text-xl font-semibold">Académic@</h1>
        </div>
        <FontAwesomeIcon icon={faTrash} />
      </div>

      <div id="options" className="flex flex-col gap-4">
        <Option name="João" surname="Capucho" selected />
        <Option name="Leandro" surname="Silva" />
        <Option name="Rúben" surname="Garrido" />
        <Option name="Zakhar" surname="Kruptsala" />
      </div>
    </div>
  );
}
