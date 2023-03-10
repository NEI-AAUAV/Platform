import { GithubIcon, LinkedinIcon } from "assets/icons/social";
import { PersonPinIcon } from "assets/icons/google";
import { useState, useRef, useEffect } from "react";
import classname from "classname";

import "./index.css";

const UserCard = ({ user }) => {
  const [loading, setLoading] = useState(false);
  user = {
    name: "Leandro",
    surname: "Silva",
    course: "Mestrado em Engenharia Informática",
    curricular_year: 3,
    github: "https://github/leand12",
    linkedin: "https://github/leand12",
  };

  function findInFamily() {
    setLoading(true);
    setTimeout(() => setLoading(false), 3000);
  }

  return (
    <div className="flex items-start gap-4">
      <div className="mask mask-circle w-16 shrink-0">
        <img
          src="https://flowbite.s3.amazonaws.com/blocks/marketing-ui/avatars/bonnie-green.png"
          alt="Bonnie Avatar"
        />
      </div>
      <div className="w-full">
        <span className="">
          {user.name} {user.surname}
        </span>
        <p className="mt-1 text-sm font-light leading-5 text-base-content/75">
          Mestrado em Engenharia Informática
          <span className="whitespace-nowrap font-light"> • 3º ano</span>
        </p>
        <div className="mt-2 flex justify-between">
          <ul className="flex space-x-1 sm:mt-0">
            {!!user.github && (
              <li>
                <a
                  href={user.github}
                  target="_blank"
                  className="btn-ghost btn-xs btn-circle btn"
                >
                  <GithubIcon />
                </a>
              </li>
            )}
            {!!user.linkedin && (
              <li>
                <a
                  href={user.linkedin}
                  target="_blank"
                  className="btn-ghost btn-xs btn-circle btn"
                >
                  <LinkedinIcon />
                </a>
              </li>
            )}
          </ul>
          <button
            className={classname(
              "btn-xs btn gap-2",
              loading && "loading disabled before:!mx-1"
            )}
            onClick={findInFamily}
          >
            {!loading && <PersonPinIcon />}Ver na Família
          </button>
        </div>
      </div>
    </div>
  );
};

const UserTooltip = ({ user, className, children }) => {
  const [hidden, setHidden] = useState(true);
  const [tooptipPos, setTooltipPos] = useState("top-right");

  const childrenRef = useRef(null);

  useEffect(() => {
    if (hidden) return;
    setTooltipPos(findBestTooltipPosition());
  }, [hidden]);

  function findBestTooltipPosition() {
    if (!childrenRef.current) return "top-right";

    const { top, bottom, left, right } =
      childrenRef.current.getBoundingClientRect();

    const { innerWidth, innerHeight } = window;

    const leftSpace = left,
      rightSpace = innerWidth - right,
      topSpace = top,
      bottomSpace = innerHeight - bottom;

    return (
      (bottomSpace > topSpace ? "top-" : "bottom-") +
      (leftSpace > rightSpace ? "right" : "left")
    );
  }

  return (
      <div
        tabIndex="0"
        role="link"
        className={`relative w-fit ${className}`}
        onMouseOver={() => setHidden(false)}
        onFocus={() => setHidden(false)}
        onMouseOut={() => setHidden(true)}
      >
        <div ref={childrenRef} className="sm:cursor-pointer">
          {children}
        </div>
        <div
          role="tooltip"
          className={classname(
            "UserTooltip rounded-box invisible absolute z-50 w-80 border border-base-300 bg-base-200 p-4 shadow transition duration-150 ease-in-out sm:!visible",
            `UserTooltip--${tooptipPos}`,
            hidden && "hidden"
          )}
        >
          <UserCard />
        </div>
      </div>
  );
};

export default UserTooltip;
