import React, { useEffect, useState } from "react";

import Person from "./components/Person.js";
import TextList from "../../components/TextList/index.js";
import { Container, Row, Spinner } from "react-bootstrap";
import Typist from "react-typist";

import service from "services/NEIService";
import config from "config/index";

import Tabs from "components/Tabs/index.js";

// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(
  process.env.REACT_APP_ANIMATION_INCREMENT
);

const Team = () => {
  const [years, setYears] = useState([]);

  const [selectedYear, setSelectedYear] = useState("2022");

  const [people, setPeople] = useState();
  const [colaborators, setColaborators] = useState();

  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    let anos = new Set();
    service.getTeamMandates().then((response) => {
      for (var i = 0; i < response.length; i++) {
        anos.add(response[i].mandate);
      }
      setYears(
        Array.from(anos.values())
          .sort((a, b) => a - b)
          .reverse()
      );
      setLoading(false);
    });
  }, []);

  useEffect(() => {
    setLoading(true);

    if (selectedYear != null) {
      const params = {
        mandate: selectedYear,
      };

      let team = [];
      let colabs = [];
      setPeople(team);
      setColaborators(colabs);
      service.getTeamMandates({ ...params }).then((response) => {
        for (var i = 0; i < response.length; i++) {
          if (response[i].mandate === selectedYear) {
            team.push({
              id: response[i].user.id,
              name: response[i].user.name,
              role: response[i].role.name,
              header: response[i].header,
              linkedIn: response[i].user.linkedin,
            });
          }
        }
        setPeople(
          team.map((person, i) => (
            <Person
              key={person.id}
              img={person.header}
              name={person.name}
              description={person.role}
              linke={person.linkedIn}
              className="slideUpFade"
              style={{
                animationDelay: animationBase + animationIncrement * i + "s",
              }}
            />
          ))
        );
      });

      service.getTeamColaborators({ ...params }).then((response) => {
        for (var i = 0; i < response.length; i++) {
          if (response[i].mandate === selectedYear) {
            colabs.push({
              id: response[i].user.id,
              name: response[i].user.name,
            });
          }
        }
        setColaborators(
          colabs.map((person, i) => <TextList colSize={4} text={person.name} />)
        );
      });
    }
    setLoading(false);
  }, [selectedYear]);

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
      <h2 className="mb-5 text-center">
        <Typist>Equipa do NEI</Typist>
      </h2>

      <Tabs
        tabs={years}
        value={selectedYear}
        onChange={setSelectedYear}
        displayAs={customTab}
      />
      {loading ? (
        <Spinner
          animation="grow"
          variant="primary"
          className="mx-auto mb-3"
          title="A carregar..."
        />
      ) : (
        <>
          <Row xs={1} lg={3}>
            {people}
          </Row>

          {colaborators != null && colaborators.length > 0 && (
            <Row className="justify-content-center">
              <h2>Colaboradores</h2>
            </Row>
          )}

          <Container>
            <Row xs={1} lg={3}>
              {colaborators}
            </Row>
          </Container>
        </>
      )}
    </div>
  );
};

export default Team;
