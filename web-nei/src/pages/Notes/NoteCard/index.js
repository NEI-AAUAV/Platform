import data from "../data";

import LinkAdapter from "utils/LinkAdapter";

import { monthsPassed } from "utils";

import malePic from "assets/default_profile/male.svg";
import femalePic from "assets/default_profile/female.svg";
import otherPic from "assets/default_profile/other.svg";

/**
 *
 * @param {ReactElement} Icon optional
 * @returns
 */
const NoteCard = ({ note, link, className, Icon, onClick, title, style }) => {
  const { author, subject } = note;
  function getTags(tag) {
    var tags = [];
    if (monthsPassed(new Date(note?.created_at)) < 3) {
      tags.push({
        name: "Novo",
        color: "38 100% 50%",
      });
    }
    for (const key of Object.keys(data.categories)) {
      if (note[key]) {
        tags.push(data.categories[key]);
      }
    }
    return tags;
  }

  return (
    <LinkAdapter
      to={link}
      onClick={onClick}
      title={title ? title : ""}
      style={style}
      className={"cursor-pointer no-underline " + className}
    >
      <div className="h-full rounded-md border border-base-content/10 !bg-base-200 p-4 shadow-sm transition-hover duration-300 hover:-translate-y-1 hover:shadow-md hover:brightness-110">
        <div className="flex items-center text-left">
          {!!Icon && <Icon className="min-h-[30px] min-w-[30px]" />}
          <p className="ml-3 overflow-hidden text-ellipsis text-sm text-base-content/50">
            <span className="mr-[1ch] font-medium text-base-content/60">
              {subject?.short}
            </span>
            {note?.year && (
              <span>
                {note.year}-{note.year + 1}
              </span>
            )}
          </p>
          {!!author && (
            <div
              className="tooltip tooltip-left avatar ml-auto mr-1"
              data-tip={`Autoria de ${author.name} ${author.surname}`}
            >
              <div className="mask mask-circle w-6">
                <img
                  src={
                    author.image ||
                    { M: malePic, F: femalePic, null: otherPic }[author.gender]
                  }
                  alt="Perfil"
                />
              </div>
            </div>
          )}
        </div>
        <div className="flex flex-col">
          <h5 className="mt-2 w-full break-words">
            {note?.name}
          </h5>

          <div className="mt-2 flex flex-wrap gap-1">
            {getTags().map((tag, index) => (
              <span
                key={index}
                className="badge badge-sm border-0 font-bold text-white truncate justify-start"
                style={{ backgroundColor: `hsl(${tag.color})` }}
              >
                {tag.name}
              </span>
            ))}
          </div>
        </div>
      </div>
    </LinkAdapter>
  );
};

export default NoteCard;
