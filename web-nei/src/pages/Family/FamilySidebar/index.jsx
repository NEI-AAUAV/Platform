import React, { Fragment, useState, useCallback, useEffect } from "react";
import PropTypes from "prop-types";

import {
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

const FamilySidebar = ({ insignias, year, setInsignias, setYear, minYear, maxYear, users }) => {
  const [endYear, setEndYear] = useState(-1);
  // const [fainaNames, setFainaNames] = useState(false);
  const [selName, setSelName] = useState(null);
  const theme = useUserStore((state) => state.theme);

  // Build dynamic organization list from users data
  // This allows showing any organization from the API, not just hardcoded ones
  const dynamicOrgs = React.useMemo(() => {
    if (!users || users.length === 0) {
      return new Map();
    }

    const orgsMap = new Map();
    let hiddenCount = 0;

    users.forEach(u => {
      u.organizations?.forEach(o => {
        // Skip hidden roles
        if (o.hidden === true) {
          hiddenCount++;
          return;
        }

        // Determine the key (same logic as data.jsx)
        let key = o.name; // org_name from API

        // If key looks like a role_id path (starts with "."), use role_name as fallback
        if (key?.startsWith(".")) {
          key = o.role_name || o.role || key;
        }

        // Special handling for ST sub-roles
        if (o.name === "ST" || key === "ST") {
          const roleMap = {
            "Mestre Escrivão": "escrivao",
            "Mestre Pescador": "pescador",
            "Mestre do Salgado": "salgado",
          };
          const mappedKey = roleMap[o.role] || roleMap[o.role_name];
          if (mappedKey) {
            key = mappedKey;
          }
        }

        if (!key) return;

        // Only add if not already present (first occurrence wins for display name)
        // But always keep the shortest (base) role_id for proper sorting
        const currentRoleId = o.role_id || '';

        if (!orgsMap.has(key)) {
          // Check if we have a hardcoded entry for this org
          const hardcodedOrg = organizations[key];

          orgsMap.set(key, {
            key: key,
            // For display name: use hardcoded name, then org_name (key), then role_name as last resort
            // This ensures NEI roles show "NEI" not "Responsável Financeiro"
            name: hardcodedOrg?.name || key,
            insignia: hardcodedOrg?.insignia || null, // Will be null for dynamic orgs without icons
            icon: o.icon, // Icon URL from API (if available)
            changeColor: hardcodedOrg?.changeColor || false,
            isHardcoded: !!hardcodedOrg,
            role_id: currentRoleId // Store role_id for sorting
          });
        } else {
          // Update with shorter role_id if found (base/parent org takes priority)
          const existing = orgsMap.get(key);
          if (currentRoleId && (!existing.role_id || currentRoleId.length < existing.role_id.length)) {
            existing.role_id = currentRoleId;
          }
        }
      });
    });


    // Sort by role_id to maintain hierarchical order from database
    const sortedEntries = [...orgsMap.entries()].sort((a, b) => {
      const roleIdA = a[1].role_id || '';
      const roleIdB = b[1].role_id || '';
      return roleIdA.localeCompare(roleIdB);
    });

    return new Map(sortedEntries);
  }, [users]);

  // const toggeFainaNames = () => {
  //   changeLabels(!fainaNames);
  //   setFainaNames(!fainaNames);
  // };

  useEffect(() => {
    if (maxYear !== null && maxYear !== undefined) {
      setEndYear(maxYear);
    }
  }, [maxYear]);

  const toggleInsignias = (name) => {
    setInsignias(prev => {
      const index = prev.indexOf(name);
      if (index !== -1) {
        return prev.filter((_, i) => i !== index);
      } else {
        return [...prev, name];
      }
    });
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

  // Helper to render organization icon
  const renderOrgIcon = (org) => {
    if (org.icon) {
      return <img src={org.icon} alt="" className="h-4 w-4" />;
    }
    if (org.insignia) {
      return (
        <img
          src={org.insignia}
          alt=""
          className="h-4 w-4"
          style={
            org.changeColor && theme === "dark"
              ? { filter: "invert(1)" }
              : {}
          }
        />
      );
    }
    return (
      <div
        className="h-4 w-4 rounded-full bg-base-content/30"
        title={`Sem ícone para ${org.name}`}
      />
    );
  };

  return (
    <>
      <h5 className="px-3 pt-3 opacity-80">Procurar Membro</h5>
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
            placeholder="Pesquisar por nome..."
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
          <button
            className={classNames(
              "btn-xs btn-circle btn mx-auto",
              minYear && endYear === minYear + 9 ? "btn-disabled" : ""
            )}
            onClick={() =>
              setEndYear((endYear) => Math.max(--endYear, (minYear || 0) + 9))
            }
            disabled={minYear && endYear === minYear + 9}
            type="button"
            aria-label="Diminuir ano"
          >
            <ExpandLessIcon />
          </button>
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
          <button
            className={classNames(
              "btn-xs btn-circle btn mx-auto",
              endYear === maxYear ? "btn-disabled" : ""
            )}
            onClick={() =>
              setEndYear((endYear) => Math.min(++endYear, maxYear || 99))
            }
            disabled={endYear === maxYear}
            type="button"
            aria-label="Aumentar ano"
          >
            <ExpandMoreIcon />
          </button>
        </div>
      </div>
      <h5 className="px-3 pt-3 opacity-80">Insígnias</h5>
      <div className="px-5 py-3">
        {[...dynamicOrgs.entries()].map(([key, org]) => (
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
            {/* Render icon: API icon takes priority over hardcoded insignia */}
            {renderOrgIcon(org)}
            <div>{org.name}</div>
          </div>
        ))}
      </div>
    </>
  );
};

export default FamilySidebar;

FamilySidebar.propTypes = {
  insignias: PropTypes.array,
  year: PropTypes.number,
  setInsignias: PropTypes.func,
  setYear: PropTypes.func,
  minYear: PropTypes.number,
  maxYear: PropTypes.number,
  users: PropTypes.array,
};
