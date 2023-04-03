import React, { useState } from "react";

import { motion } from "framer-motion";

import {
  TuneIcon,
  CloseIcon,
  FullScreenIcon,
  FullScreenExitIcon,
  FamilyIcon,
  FainaFamilyIcon,
} from "assets/icons/google";

import classNames from "classnames";

import { MAX_YEAR } from "./data";

import FamilyContent from "./FamilyContent";
import FamilySidebar from "./FamilySidebar";
import "./index.css";

function Family() {
  const [auth, setAuth] = useState(!!localStorage.getItem("treeei"));
  const [pass, setPass] = useState("");
  const [expanded, setExpanded] = useState(false);
  const [sidebarOpened, setSidebarOpened] = useState(false);

  const [insignias, setInsignias] = useState([]);
  const [year, setYear] = useState(MAX_YEAR);

  const validatePass = () => {
    if (pass.toLowerCase()) {
      localStorage.setItem("treeei", true);
      setAuth(true);
    }
  };

  if (!auth) {
    return (
      <div
        className="flex grow items-center justify-center"
      >
        <div style={{ display: "flex", justifyContent: "center" }}>
          <input
            type="password"
            className="input-bordered input w-56 pr-[4.5rem] placeholder:font-normal placeholder:text-base-content/50"
            placeholder="Password"
            onChange={(e) => setPass(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && validatePass()}
            value={pass}
          />
        </div>
      </div>
    );
  }
  return (
    <motion.div
      className={classNames("w-full ", {
        expand: expanded,
      })}
      id="treeei"
      animate={expanded ? "expand" : "normal"}
      transition={{ duration: 0.15 }}
      variants={{
        expand: { y: -80, height: "100vh", zIndex: 1000 },
        normal: {
          y: 0,
          height: "calc(100vh - 9rem)",
          zIndex: 0,
          transition: {
            duration: 0.15,
            zIndex: { delay: 0.15 },
          },
        },
      }}
    >
      <div className="drawer h-full">
        <input
          type="checkbox"
          className="drawer-toggle"
          checked={sidebarOpened}
          onChange={(e) => setSidebarOpened(e.target.checked)}
        />
        <div className="drawer-content !overflow-hidden">
          <FamilyContent insignias={insignias} year={year} auth={auth} />
        </div>
        <div
          className={classNames(
            "drawer-side pointer-events-none relative !flex h-full !overflow-hidden py-5",
            { "px-1": sidebarOpened }
          )}
        >
          <div className="drawer-overlay hidden" />
          <div
            className={classNames(
              "rounded-l-box relative mr-12 !flex h-full w-80 text-base-content !transition-size",
              sidebarOpened
                ? "pointer-events-auto border border-r-0 border-base-content/10 bg-base-200 shadow-[0_1px_3px_-1px_rgba(0,0,0,0.1)]"
                : "bg-transparent"
            )}
          >
            <div className="rounded-box my-2 ml-2 w-full overflow-hidden border-base-content/10 bg-base-300">
              <div className="h-full overflow-y-auto">
                <FamilySidebar
                  insignias={insignias}
                  year={year}
                  setInsignias={setInsignias}
                  setYear={setYear}
                />
              </div>
            </div>
            <div
              className={classNames(
                "rounded-r-box absolute left-full -top-px -bottom-px flex w-12 flex-col items-center gap-3 overflow-hidden py-3 !transition-size",
                sidebarOpened
                  ? "border  border-l-0 border-base-content/10 bg-base-200 shadow-[1px_1px_3px_-1px_rgba(0,0,0,0.1)]"
                  : "bg-transparent"
              )}
            >
              <label className="pointer-events-auto swap-rotate swap btn-sm btn-circle btn">
                <input
                  type="checkbox"
                  checked={sidebarOpened}
                  onChange={(e) => setSidebarOpened(e.target.checked)}
                />
                <CloseIcon className="swap-on" />
                <TuneIcon className="swap-off" />
              </label>
              <label className="pointer-events-auto swap-rotate swap btn-sm btn-circle btn">
                <input
                  type="checkbox"
                  checked={expanded}
                  onChange={(e) => setExpanded(e.target.checked)}
                />
                <FullScreenExitIcon className="swap-on" />
                <FullScreenIcon className="swap-off" />
              </label>
              <label className="pointer-events-auto swap-rotate swap btn-disabled btn-sm btn-circle btn">
                <input type="checkbox" />
                <FamilyIcon className="swap-on" />
                <FainaFamilyIcon className="swap-off" />
              </label>
            </div>
          </div>
        </div>
      </div>
    </motion.div>
  );
}

export default Family;
