import React, { useEffect, useState } from "react";

import Person from "./components/Person.js";
import { Spinner } from "react-bootstrap";
import Typist from "react-typist";

import service from "services/NEIService";

import Tabs from "components/Tabs/index.js";

import classNames from "classnames";

import { LinkedinIcon, GithubIcon } from "assets/icons/social";

const Team = () => {
  const [years, setYears] = useState([]);

  const [selectedYear, setSelectedYear] = useState(null);

  const [team, setTeam] = useState();
  const [collaborators, setCollaborators] = useState();

  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    service.getTeamMandates().then(({ data }) => {
      const years = data.sort().reverse();
      setYears(years);
      setSelectedYear(years[0]);
      setLoading(false);
    });
  }, []);

  useEffect(() => {
    setLoading(true);

    if (!selectedYear) return;
    const params = {
      mandate: selectedYear,
    };

    setTeam(null);
    setCollaborators(null);
    Promise.all([
      service.getTeamMembers({ ...params }).then((members) => {
        members.sort(
          ({ role: a }, { role: b }) =>
            b?.weight - a?.weight || a?.name?.localeCompare(b?.name)
        );
        setTeam([
          { members: members.slice(0, 2), title: "Coordenação" },
          { members: members.slice(2, -3), title: "Vogais" },
          { members: members.slice(-3), title: "Mesa da RGM" },
        ]);
      }),
      service.getTeamCollaborators({ ...params }).then((colabs) => {
        colabs.sort(({ user: a }, { user: b }) =>
          a?.name?.localeCompare(b?.name)
        );
        setCollaborators(colabs);
      }),
    ]).then(() => setLoading(false));
  }, [selectedYear]);

  function customRender(tab) {
    const t = tab.split("/");
    return (
      <>
        {t[0]}
        {t[1] && <small className="opacity-60">/{t[1]}</small>}
      </>
    );
  }

  return (
    <div className="d-flex flex-column flex-wrap">
      <h2 className="text-center">
        <Typist>Equipa do NEI</Typist>
      </h2>

      <div className="my-10">
        <Tabs
          tabs={years}
          value={selectedYear}
          onChange={setSelectedYear}
          renderTab={customRender}
        />
      </div>
      {loading ? (
        <Spinner
          animation="grow"
          variant="primary"
          className="mx-auto mb-3"
          title="A carregar..."
        />
      ) : (
        <div className="mx-auto max-w-5xl">
          {team?.map(({ members, title }, index) => (
            <>
              <div className="flex gap-5 px-2">
                <h4 className="opacity-80">{title}</h4>
                <div className="divider mt-1 grow" />
              </div>
              <div
                key={index}
                className={classNames("flex flex-wrap justify-center sm:gap-5")}
              >
                {members?.map(({ id, role, header, user }) => (
                  <div
                    key={id}
                    className="grow-0 basis-36 px-3 py-1.5 text-center sm:basis-56 sm:px-6 sm:py-3"
                  >
                    <img
                      src={header}
                      className="mx-auto mb-4 max-w-[90px] rounded-full shadow-lg sm:max-w-[130px]"
                      alt=""
                    />

                    <p className="mb-1 text-lg font-bold">{user?.name}</p>
                    <p className="mb-2 text-gray-500">{role?.name}</p>
                    <ul className="flex justify-center space-x-1 sm:mt-0">
                      {!!user?.github && (
                        <li>
                          <a
                            href={user?.github}
                            target="_blank"
                            className="btn-ghost btn-xs btn-circle btn"
                          >
                            <GithubIcon />
                          </a>
                        </li>
                      )}
                      {!!user?.linkedin && (
                        <li>
                          <a
                            href={user?.linkedin}
                            target="_blank"
                            className="btn-ghost btn-xs btn-circle btn"
                          >
                            <LinkedinIcon />
                          </a>
                        </li>
                      )}
                    </ul>
                  </div>
                ))}
              </div>
            </>
          ))}

          {collaborators?.length > 0 && (
            <div className="flex gap-5 px-2">
              <h4 className="opacity-80">Colaboradores</h4>
              <div className="divider mt-1 grow" />
            </div>
          )}

          <div className="mt-2 grid grid-cols-2 xs:grid-cols-3 md:grid-cols-4">
            {collaborators?.map(({ user_id, user }) => (
              <h5 key={user_id} className="px-7 sm:px-14">
                {user?.name}
              </h5>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default Team;
