import { useState } from "react";

import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faCompress,
  faExpand,
  faSitemap,
  faGripHorizontal,
  faChevronDown,
  faChevronUp,
  faArrowUp,
  faArrowDown,
  faAngleLeft,
  faAngleRight,
} from "@fortawesome/free-solid-svg-icons";

import { MAX_YEAR, MIN_YEAR, handleSearchChange, organizations, colors, searchData, changeLabels } from "../data";

import { useUserStore } from "stores/useUserStore";

import classNames from "classnames";

import Autocomplete from "@mui/material/Autocomplete";
import Box from "@mui/material/Box";
import TextField from "@mui/material/TextField";


const Modes = {
  TREE: 1,
  YEAR: 2,
};

const FamilySidebar = ({ insignias, year, expanded, setInsignias, setYear, setExpanded }) => {
  const [showInfo, setShowInfo] = useState(false);
  const [mode, setMode] = useState(Modes.TREE);
  const [endYear, setEndYear] = useState(MAX_YEAR);
  const [fainaNames, setFainaNames] = useState(false);
  const theme = useUserStore(state => state.theme);

  const toggleShowInfo = () => {
    setShowInfo(!showInfo);
  };

  const toggleExpand = () => {
    setExpanded(!expanded);
  };

  const toggleMode = () => {
    setMode(mode === Modes.TREE ? Modes.FAINA : Modes.TREE);
  };

  const toggeFainaNames = () => {
    changeLabels(!fainaNames);
    setFainaNames(!fainaNames);
  };

  const toggleInsignias = (name) => {
    const i = insignias.indexOf(name);

    if (i !== -1) insignias.splice(i, 1);
    else insignias.push(name);

    setInsignias([...insignias]);
  };

  

  return (
    <>
      <button className="side-bar-button" onClick={toggleShowInfo}>
        <span>
          <FontAwesomeIcon
            icon={showInfo ? faAngleLeft : faAngleRight}
            size={"sm"}
          />
        </span>
      </button>
      <div className={classNames("side-bar-body", { hide: !showInfo })}>
        <div className="side-bar-content">
          <div className="mb-3">
            <div
              className="d-flex align-items-center justify-content-around"
              style={{ minHeight: 32 }}
            >
              <FontAwesomeIcon
                onClick={toggleExpand}
                className="menu-icon"
                icon={expanded ? faCompress : faExpand}
                size="lg"
              />
              <FontAwesomeIcon
                style={{ cursor: "not-allowed", opacity: 0.25 }}
                onClick={toggleMode}
                className="menu-icon"
                icon={mode === Modes.TREE ? faGripHorizontal : faSitemap}
                size={mode === Modes.TREE ? "2x" : "lg"}
              />
            </div>
          </div>

          <h4>Procurar</h4>
          <Autocomplete
            id="country-select-demo"
            sx={{ width: 200 }}
            options={searchData}
            onChange={handleSearchChange}
            autoHighlight
            freeSolo
            getOptionLabel={(option) => `${option.name}`}
            renderOption={(props, option) => (
              <Box {...props} key={`${option.id}`} component="li">
                <div
                  className="color-bullet"
                  style={{ backgroundColor: option.color }}
                ></div>
                {option.name}
              </Box>
            )}
            renderInput={(params) => (
              <TextField
                {...params}
                sx={{
                  mt: 1,
                  flex: 1,
                  "& legend": { display: "none" },
                  "& fieldset": {
                    top: 0,
                    borderColor: "var(--border) !important",
                  },
                  "& .MuiOutlinedInput-root": {
                    padding: "4px",
                    color: "var(--text-primary)",
                  },
                }}
                placeholder="Nome..."
                InputLabelProps={{ className: "autocompleteLabel" }}
                inputProps={{
                  ...params.inputProps,
                  autoComplete: "off", // disable autocomplete and autofill
                }}
              />
            )}
          />

          <h4>Nomes</h4>
          <div className="mt-3">
            <div
              className="mb-2"
              style={{
                fontWeight: fainaNames ? 400 : 300,
                opacity: fainaNames ? 1 : 0.7,
                cursor: "pointer",
              }}
              onClick={toggeFainaNames}
            >
              Mostrar nomes de faina
            </div>
          </div>

          <h4>Matrículas</h4>
          <div className="d-flex justify-content-between my-3 p-1">
            <div className="mr-3">
              <div style={{ marginBottom: "0.2em" }}>
                <FontAwesomeIcon
                  onClick={() =>
                    setEndYear((endYear) => Math.max(--endYear, MIN_YEAR + 9))
                  }
                  style={
                    endYear === MIN_YEAR + 9
                      ? { opacity: 0.5 }
                      : { cursor: "pointer" }
                  }
                  icon={faArrowUp}
                  size="sm"
                />
              </div>
              {[...Array(5).keys()]
                .map((i) => endYear - 9 + i)
                .map((i) => (
                  <div
                    key={i}
                    className={classNames("color-legend", {
                      inactive: i > year,
                    })}
                    onClick={() => setYear(i)}
                  >
                    <div
                      className="color-bullet"
                      style={{ backgroundColor: colors[i % colors.length] }}
                    ></div>
                    {2000 + i}
                  </div>
                ))}
            </div>
            <div className="mr-3">
              {[...Array(5).keys()]
                .map((i) => endYear - 4 + i)
                .map((i) => (
                  <div
                    key={i}
                    className={classNames("color-legend", {
                      inactive: i > year,
                    })}
                    onClick={() => setYear(i)}
                  >
                    <div
                      className="color-bullet"
                      style={{ backgroundColor: colors[i % colors.length] }}
                    ></div>
                    {2000 + i}
                  </div>
                ))}
              <div style={{ marginBottom: "0.2em" }}>
                <FontAwesomeIcon
                  onClick={() =>
                    setEndYear((endYear) => Math.min(++endYear, MAX_YEAR))
                  }
                  style={
                    endYear === MAX_YEAR
                      ? { opacity: 0.5 }
                      : { cursor: "pointer" }
                  }
                  icon={faArrowDown}
                  size="sm"
                />
              </div>
            </div>
          </div>
          <h4>Insígnias</h4>
          <div className="mr-auto mt-3">
            {Object.entries(organizations).map(([key, org]) => (
              <div
                key={key}
                className={classNames("insignia", {
                  inactive: insignias.length !== 0 && !insignias.includes(key),
                })}
                onClick={() => toggleInsignias(key)}
              >
                <img
                  src={org.insignia}
                  style={
                    org.changeColor && theme === "dark"
                      ? { filter: "invert(1)" }
                      : {}
                  }
                />
                <div>{org.name}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </>
  );
};

export default FamilySidebar;
