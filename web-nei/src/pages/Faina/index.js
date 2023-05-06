import React, { useState, useEffect, Fragment } from "react";
import { Spinner } from "react-bootstrap";
import { AnimatePresence, motion } from "framer-motion";

import Typist from "react-typist";
import service from "services/NEIService";
import Tabs from "components/Tabs";
import Popover, { UserPopover } from "components/Popover";

import {
  DecorativeSepBottom,
  DecorativeSepMiddle,
  DecorativeSepTop,
} from "assets/abstract";

const item = {
  hidden: { x: 0, y: 0, opacity: 0 },
  visible: {
    transition: { duration: 0.4 },
    opacity: 1,
  },
  slide: {
    transition: { delay: 0.1, duration: 0.4 },
    x: -20,
    opacity: 1,
  },
};

const Faina = () => {
  const [people, setPeople] = useState();
  const [tabs, setTabs] = useState([]);
  const [selectedTab, setSelectedTab] = useState();
  const [fainaImg, setFainaImg] = useState(null);

  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mandates = [];
    service.getFainaMandates().then((response) => {
      for (var i = 0; i < response.length; i++) {
        mandates.push(response[i].mandate);
      }
      if (mandates.length > 0) {
        setTabs(mandates.reverse());
        setSelectedTab(mandates[0]);
      }
    });
  }, []);

  useEffect(() => {
    setLoading(true);
    let members = [];
    service.getFainaMandates().then((response) => {
      for (var i = 0; i < response.length; i++) {
        if (response[i].mandate === selectedTab) {
          if (response[i].image) {
            setFainaImg(response[i].image);
          } else {
            setFainaImg(null);
          }
          for (var j = 0; j < response[i].members.length; j++) {
            members.push({
              role: response[i].members[j].role.name,
              name: response[i].members[j].member.name,
            });
          }
        }
      }
      setPeople(members);
      setLoading(false);
    });
  }, [selectedTab]);

  function customTabRender(tab) {
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
      <div style={{ whiteSpace: "pre", overflowWrap: "break-word" }}>
        <h2 className="mb-5 text-center">
          <Typist>Comissões de Faina</Typist>
        </h2>
      </div>

      <div className="my-8">
        <Tabs
          tabs={tabs}
          value={selectedTab}
          onChange={setSelectedTab}
          renderTab={customTabRender}
          underlineColor="bg-[#D7A019]"
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
        <div className="flex flex-col items-center justify-center xl:flex-row">
          <AnimatePresence>
            {fainaImg && (
              <motion.div
                className="max-w-3xl"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                transition={{ duration: 0.4 }}
              >
                <img
                  src={fainaImg}
                  className="h-full w-full rounded-lg object-cover object-center shadow-md"
                />
              </motion.div>
            )}
          </AnimatePresence>
          <motion.div
            className="card !ml-10 !mr-0 !mt-10 flex h-fit w-96 items-center !bg-base-200 !bg-opacity-60 shadow-md !backdrop-blur-lg xl:!mx-0"
            variants={item}
            initial="hidden"
            animate={fainaImg ? "slide" : "visible"}
          >
            <DecorativeSepTop className="text-[#D7A019]" />

            <h4 className="uppercase">
              Comissão de Faina {selectedTab?.slice(2)}
            </h4>
            <DecorativeSepMiddle className="text-[#D7A019]" />

            <div className="flex flex-col items-center">
              {people.map((person, index) => (
                <Fragment key={index}>
                  {/* <UserPopover
                    className="sm:hover:underline sm:hover:decoration-2"
                    user={person}
                  >
                    <span className="p-1 font-medium uppercase">
                      <span className="font-medium text-[#D7A019]">
                        {person.role}
                      </span>
                      {` ${person.name}`}
                    </span>
                  </UserPopover> */}

                  <span className="p-1 font-medium uppercase">
                    <span className="font-medium text-[#D7A019]">
                      {person.role}
                    </span>
                    {` ${person.name}`}
                  </span>
                </Fragment>
              ))}
            </div>

            <DecorativeSepBottom className="text-[#D7A019]" />
          </motion.div>
        </div>
      )}
    </div>
  );
};

export default Faina;
