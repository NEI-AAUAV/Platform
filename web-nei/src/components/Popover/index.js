import { GithubIcon, LinkedinIcon } from "assets/icons/social";
import { PersonPinIcon } from "assets/icons/google";
import { useState, useRef, useEffect } from "react";
import classNames from "classnames";
import { useWindowSize } from "utils/hooks";

import "./index.css";

export const UserPopover = ({ user, ...popoverProps }) => {
  const [loading, setLoading] = useState(false);

  user = user || {
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

  const User = () => (
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
            className={classNames(
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

  return <Popover {...popoverProps} popover={<User user={user} />} />;
};

/**
 * A popover to display additional information when hovering a component.
 *
 * @param {ReactNode} popover - the content of the popover
 * @param {ReactNode} children - the component that triggers the popover on hover
 * @param {string} className - the class name of the popover
 */
const Popover = ({ popover, children, className }) => {
  const [visible, setVisible] = useState(false);
  const [popoverPos, setPopoverPos] = useState("top-right");

  const childrenRef = useRef(null);

  const windowSize = useWindowSize();

  useEffect(() => {
    if (!visible) {
      return;
    }
    setPopoverPos(findBestPopoverPosition());
  }, [visible]);

  function findBestPopoverPosition() {
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
      className={`relative w-fit ${className}`}
      onFocus={() => setVisible(true)}
      onMouseOver={() => setVisible(true)}
      onMouseOut={() => setVisible(false)}
    >
      <div
        ref={childrenRef}
        tabIndex="0"
        role="link"
        className="sm:cursor-pointer"
      >
        {children}
      </div>
      {visible && (
        <div
          role="popover"
          className={classNames(
            "invisible absolute z-50 min-w-[320px] rounded-lg border border-base-content/10 bg-base-300 p-4 sm:visible",
            windowSize.width >= 640
              ? `Popover Popover--${popoverPos}`
              : "left-1/2 right-1/2 top-10 -translate-x-1/2"
          )}
        >
          {popover}
        </div>
      )}
    </div>
  );
};

export default Popover;
