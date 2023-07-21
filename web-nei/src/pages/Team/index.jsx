import React, { useEffect, useState } from "react";

import { Spinner } from "react-bootstrap";
import Typist from "react-typist";
import { motion } from "framer-motion";

import service from "services/NEIService";

import Tabs from "components/Tabs/index";

import classNames from "classnames";

import { LinkedinIcon, GithubIcon } from "assets/icons/social";

const container = {
  hidden: { opacity: 1, scale: 0 },
  visible: {
    opacity: 1,
    scale: 1,
    transition: {
      delayChildren: 0.2,
      staggerChildren: 0.1,
    },
  },
};

const item = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
  },
};

export function Component() {
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
        <motion.div
          className="mx-auto max-w-5xl"
          variants={container}
          initial="hidden"
          animate="visible"
        >
          {team?.map(({ members, title }, index) => (
            <motion.div key={index} variants={item}>
              <div className="flex gap-5 px-2">
                <h4 className="opacity-80">{title}</h4>
                <div className="divider mt-1 grow" />
              </div>
              <div
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

                    <p className="mb-1 text-lg font-bold">
                      {user?.name} {user?.surname}
                    </p>
                    <p className="mb-2 text-gray-500">{role?.name}</p>
                    <ul className="flex justify-center space-x-1 sm:mt-0">
                      {!!user?.github && (
                        <li>
                          <a
                            href={user?.github}
                            target="_blank"
                            rel="noreferrer"
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
                            rel="noreferrer"
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
            </motion.div>
          ))}

          {collaborators?.length > 0 && (
            <motion.div variants={item}>
              <div className="flex gap-5 px-2">
                <h4 className="opacity-80">Colaboradores</h4>
                <div className="divider mt-1 grow" />
              </div>
              <div className="mt-2 grid grid-cols-[repeat(auto-fit,_minmax(28ch,_1fr))]">
                {collaborators?.map(({ user_id, user }) => (
                  <h5 key={user_id} className="px-7">
                    {user?.name} {user?.surname}
                  </h5>
                ))}
              </div>
            </motion.div>
          )}
        </motion.div>
      )}
    </div>
  );
}
