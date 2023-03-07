import React, { useState, useEffect, Fragment } from "react";
import { Row, Spinner } from "react-bootstrap";

import Typist from "react-typist";
import service from "services/NEIService";
import Tabs from "components/Tabs";
import UserTooltip from "components/UserTooltip";

import {
  DecorativeSepBottom,
  DecorativeSepMiddle,
  DecorativeSepTop,
} from "assets/abstract";


const Faina = () => {
  const [people, setPeople] = useState([]);
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
    setLoading(false);
  }, []);

  useEffect(() => {
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
    });
    setLoading(false);
  }, [selectedTab]);

  function customTab(tab) {
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
          displayAs={customTab}
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
        <div className="flex flex-wrap justify-center gap-10">
          {fainaImg && (
            <img
              src={fainaImg}
              className="max-h-[60vh] w-full max-w-3xl rounded-lg shadow-md"
            />
          )}
          <div className="card !mx-0 flex w-96 items-center !bg-base-200 shadow-md">
            <DecorativeSepTop className="text-[#D7A019]" />

            <h4 className="uppercase">
              Comissão de Faina {selectedTab?.slice(2)}
            </h4>
            <DecorativeSepMiddle className="text-[#D7A019]" />

            <div className="flex flex-col items-center">
              {people.map((person, index) => (
                <Fragment key={index}>
                  <UserTooltip className="hover:underline hover:decoration-2">
                    <span className="p-1 font-medium uppercase">
                      <span className="font-medium text-[#D7A019]">{person.role}</span>
                      {"" + " " + person.name}
                    </span>
                  </UserTooltip>
                </Fragment>
              ))}
            </div>

            <DecorativeSepBottom className="text-[#D7A019]" />
          </div>
        </div>
      )}
    </div>
  );
};

export default Faina;
