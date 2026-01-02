import { Fragment, useState, useCallback, useEffect } from "react";

import {
  MAX_YEAR,
  MIN_YEAR,
  handleSearchChange,
  organizations,
  colors,
  searchData,
  changeLabels,
} from "../data";

import { useUserStore } from "stores/useUserStore";

import classNames from "classnames";

import Autocomplete from "components/Autocomplete";
import { ExpandMoreIcon, ExpandLessIcon } from "assets/icons/google";

const FamilySidebar = ({ insignias, year, setInsignias, setYear }) => {
  const [endYear, setEndYear] = useState(-1);
  // const [fainaNames, setFainaNames] = useState(false);
  const [selName, setSelName] = useState(null);
  const theme = useUserStore((state) => state.theme);

  // const toggeFainaNames = () => {
  //   changeLabels(!fainaNames);
  //   setFainaNames(!fainaNames);
  // };

  useEffect(() => {
    setEndYear(MAX_YEAR);
  }, []);

  const toggleInsignias = (name) => {
    const i = insignias.indexOf(name);

    if (i !== -1) insignias.splice(i, 1);
    else insignias.push(name);

    setInsignias([...insignias]);
  };

  const customRenderOption = (item) => (
    <>
      <div
        className="inline-block h-3 w-3 rounded-full"
        style={{ backgroundColor: item.color }}
      />
      {item.label}
    </>
  );

  const BulletYear = useCallback(
    ({ color, index }) => (
      <div
        className={classNames(
          "cursor-pointer py-0.5",
          index > year ? "font-normal opacity-70" : "font-medium"
        )}
        onClick={() => setYear(index)}
      >
        <div
          className="ml-1.5 mr-2 inline-block h-3 w-3 rounded-full p-1"
          style={{ backgroundColor: color }}
        ></div>
        {2000 + index}
      </div>
    ),
    [year]
  );

  function handleChange(key) {
    setSelName(key);
    handleSearchChange(searchData.find((item) => item.id === key));
  }

  return (
    <>
      <h5 className="px-3 pt-3 opacity-80">Procurar</h5>
      <div className="px-3 py-3">
        <div className="w-56">
          <Autocomplete
            items={searchData.map((item) => ({
              key: item.id,
              label: item.name,
              color: item.color,
            }))}
            value={selName}
            onChange={handleChange}
            placeholder="Nome"
            renderOption={customRenderOption}
          />
        </div>
      </div>
      {/* <Autocomplete
            id="country-select-demo"
            sx={{ width: 200 }}
            options={searchData}
            onChange={handleSearchChange}
            autoHighlight
            freeSolo
            getOptionLabel={(option) => `${option.name}`}
            renderTab={(props, option) => (
              <Box {...props} key={`${option.id}`} component="li">
                <div
                  className="color-bulletYear"
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
                  autoComplete: "off",
                }}
              />
            )}
          /> */}
      {/* 
      <h5 className="px-3 pt-3 opacity-80">Nomes</h5>
      <div className="px-5 py-3">
        <div
          className={classNames(
            "mb-2 cursor-pointer",
            fainaNames ? "font-medium" : "font-normal opacity-70"
          )}
          onClick={toggeFainaNames}
        >
          Mostrar nomes de faina
        </div>
      </div> */}

      <h5 className="px-3 pt-3 opacity-80">Matrículas</h5>
      <div className="flex justify-start gap-10 px-5 py-3">
        <div>
          <div
            className={classNames(
              "btn-xs btn-circle btn mx-auto",
              endYear === MIN_YEAR + 9 ? "btn-disabled" : "cursor-pointer"
            )}
            onClick={() =>
              setEndYear((endYear) => Math.max(--endYear, MIN_YEAR + 9))
            }
          >
            <ExpandLessIcon />
          </div>
          {[...Array(5).keys()]
            .map((i) => endYear - 9 + i)
            .map((i) => (
              <Fragment key={i}>
                <BulletYear color={colors[i % colors.length]} index={i} />
              </Fragment>
            ))}
        </div>
        <div>
          {[...Array(5).keys()]
            .map((i) => endYear - 4 + i)
            .map((i) => (
              <Fragment key={i}>
                <BulletYear color={colors[i % colors.length]} index={i} />
              </Fragment>
            ))}
          <div
            className={classNames(
              "btn-xs btn-circle btn mx-auto",
              endYear === MAX_YEAR ? "btn-disabled" : "cursor-pointer"
            )}
            onClick={() =>
              setEndYear((endYear) => Math.min(++endYear, MAX_YEAR))
            }
          >
            <ExpandMoreIcon />
          </div>
        </div>
      </div>
      <h5 className="px-3 pt-3 opacity-80">Insígnias</h5>
      <div className="px-5 py-3">
        {Object.entries(organizations).map(([key, org]) => (
          <div
            key={key}
            className={classNames(
              "mb-1 flex cursor-pointer items-center gap-3 font-medium",
              {
                "!font-normal opacity-70":
                  insignias.length !== 0 && !insignias.includes(key),
              }
            )}
            onClick={() => toggleInsignias(key)}
          >
            <img
              src={org.insignia}
              className="h-4 w-4"
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
    </>
  );
};

export default FamilySidebar;
