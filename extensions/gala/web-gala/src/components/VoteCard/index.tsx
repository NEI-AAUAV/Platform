import { faGraduationCap, faTrash } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Avatar from "../Avatar";

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
        <div className="flex flex-row items-center gap-2 rounded-lg border border-[#EBD5B5] bg-gradient-to-r from-[#EBD5B5] to-[#B6A080] p-2 shadow-[0_2px_6px_0px_rgba(182,160,128,0.25)]">
          <Avatar id={null} className="w-[16px] flex-initial" />
          <p>
            <span className="font-semibold">João</span> Capucho
          </p>
        </div>
        <div className="flex flex-row items-center gap-2 rounded-lg border border-[#EBD5B5] p-2 shadow-[0_2px_6px_0px_rgba(182,160,128,0.25)]">
          <Avatar id={null} className="w-[16px] flex-initial" />
          <p>
            <span className="font-semibold">Leandro</span> Silva
          </p>
        </div>
        <div className="flex flex-row items-center gap-2 rounded-lg border border-[#EBD5B5] p-2 shadow-[0_2px_6px_0px_rgba(182,160,128,0.25)]">
          <Avatar id={null} className="w-[16px] flex-initial" />
          <p>
            <span className="font-semibold">Rúben</span> Garrido
          </p>
        </div>
        <div className="flex flex-row items-center gap-2 rounded-lg border border-[#EBD5B5] p-2 shadow-[0_2px_6px_0px_rgba(182,160,128,0.25)]">
          <Avatar id={null} className="w-[16px] flex-initial" />
          <p>
            <span className="font-semibold">Zakhar</span> Kruptsala
          </p>
        </div>
      </div>
    </div>
  );
}
