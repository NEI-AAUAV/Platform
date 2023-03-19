import React, { useState } from "react";

import { TuneIcon, CloseIcon } from "assets/icons/google";

import classNames from "classnames";

import TextField from "@mui/material/TextField";

import { MAX_YEAR } from "./data";

import FamilyContent from "./FamilyContent";
import FamilySidebar from "./FamilySidebar";
import "./index.css";

function Family() {
  const [auth, setAuth] = useState(!!localStorage.getItem("treeei"));
  const [pass, setPass] = useState("");
  const [expanded, setExpanded] = useState(false);

  const [insignias, setInsignias] = useState([]);
  const [year, setYear] = useState(MAX_YEAR);

  const validatePass = () => {
    if (pass.toLowerCase() === "ei2022") {
      localStorage.setItem("treeei", true);
      setAuth(true);
    }
  };

  if (!auth) {
    return (
      <div
        style={{
          display: "flex",
          zIndex: 1000,
          justifyContent: "center",
          alignItems: "center",
          flexDirection: "column",
          height: "80vh",
        }}
      >
        <div style={{ display: "flex", justifyContent: "center" }}>
          <TextField
            id="pass"
            placeholder="Password"
            type="password"
            label={null}
            variant="outlined"
            sx={{
              mt: 1,
              flex: 1,
              "& legend": { display: "none" },
              "& fieldset": { top: 0, borderColor: "var(--border) !important" },
              "& .MuiInputBase-input": { p: 1 },
              "& .MuiOutlinedInput-root": {
                padding: "4px",
                color: "var(--text-primary)",
              },
            }}
            onChange={(e) => setPass(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && validatePass()}
            value={pass}
          />
        </div>
      </div>
    );
  }
  return (
    <div
      id="treeei"
      className={classNames("flex-grow-1 flex after:shadow-inner", {
        expand: expanded,
      })}
    >
      <div className="drawer h-full">
        <input id="my-drawer" type="checkbox" className="drawer-toggle" />
        <div className="drawer-content !overflow-hidden">
          <FamilyContent insignias={insignias} year={year} auth={auth} />
        </div>
        <div className="drawer-side w-80">
          <div className="drawer-overlay hidden" />
          <ul className="relative mr-10 flex h-[calc(100vh-9rem)] grow bg-base-200 text-base-content ">
            <div className="w-full overflow-y-auto p-4">
              <FamilySidebar insignias={insignias} year={year} expanded={expanded} setInsignias={setInsignias} setYear={setYear} setExpanded={setExpanded} />
            </div>

            <div className="rounded-r-box absolute left-full top-0 h-full w-10 overflow-hidden border-r border-base-content/10 bg-base-200">
              <label
                htmlFor="my-drawer"
                className="indicator rounded-r-box h-full w-full cursor-pointer transition-colors duration-300 hover:bg-base-content/10"
              >
                <span
                  className="mx-auto my-4 flex rotate-180 items-center justify-end gap-3 text-xs font-medium uppercase tracking-widest text-base-content/60"
                  style={{
                    writingMode: "vertical-rl",
                    textOrientation: "mixed",
                  }}
                >
                  Configurações
                  <div className="drawer-swap swap">
                    <TuneIcon className="swap-off" />
                    <CloseIcon className="swap-on" />
                  </div>
                </span>
                <span className="badge indicator-center indicator-middle indicator-item h-10 w-1 border-0 bg-base-content/40 p-0"></span>
              </label>
            </div>
          </ul>
        </div>
      </div>
    </div>
  );
}

export default Family;
