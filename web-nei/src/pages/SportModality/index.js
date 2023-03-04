import React, { useState, useEffect } from "react";

import Typist from "react-typist";
import SideBar from "./components/SideBar";
import { Row, Col } from "react-bootstrap";
import Game from "./components/Game";
import Dropdown from "react-bootstrap/Dropdown";
import img from "./components/football.png";

import "./index.css";
import GameFilter from "./components/GameFilter";
import SportClassification from "./SportClassification";
import SportBracket from "./SportBracket"
import SportTeam from "./SportTeam";
import { useParams, useNavigate } from "react-router";

const SportModality = () => {
  const navigate = useNavigate();
  const params = useParams();

  useEffect(() => {
    if (!params.view) {
      navigate("games")
    }
  }, [params])

  const selectChange = (value) => {
    const url = `/taca-ua/${params.id}/`;
    switch (value) {
      case "games":
        navigate(url + "games");
        break;
      case "classification":
        navigate(url + "classification");
        break;
      case "team":
        navigate(url + "team");
        break;
      default:
        return;
    }
  };

  return (
    <>
      <div className="d-flex flex-column flex-wrap">
        <h2 className="mb-5 text-center">
          <Typist>Desporto</Typist>
        </h2>
      </div>
      <div className="bars">
        <SideBar />
        <div className="games-and-top-bar">
          <div className="top-bar">
            <div className="top-bar-items">
              <div className="top-bar-image-wrapper">
                <img src={img}></img>
              </div>
              <div className="top-bar-items-header">
                <h3>Futsal Masculino</h3>
                <Dropdown
                  className="top-bar-items-header-dropdown"
                  style={{ outline: "none" }}
                >
                  <Dropdown.Toggle
                    id="dropdown-basic"
                    style={{
                      border: "none",
                      background: "none",
                      color: "#000",
                    }}
                  >
                    2019
                  </Dropdown.Toggle>

                  <Dropdown.Menu>
                    <Dropdown.Item>2019</Dropdown.Item>
                    <Dropdown.Item>2020</Dropdown.Item>
                  </Dropdown.Menu>
                </Dropdown>
              </div>
            </div>
            <div className="top-bar-items-list">
              <ul>
                <li
                  className={
                    params.view === "games"
                      ? "top-bar-item-active"
                      : "top-bar-list-item"
                  }
                  onClick={() => selectChange("games")}
                >
                  Jogos
                </li>
                <li
                  className={
                    params.view === "classification"
                      ? "top-bar-item-active"
                      : "top-bar-list-item"
                  }
                  onClick={() => selectChange("classification")}
                >
                  Classificações
                </li>
                <li
                  className={
                    params.view === "team"
                      ? "top-bar-item-active"
                      : "top-bar-list-item"
                  }
                  onClick={() => selectChange("team")}
                >
                  Equipa
                </li>
              </ul>
            </div>
          </div>
          {params.view === "games" && (
            <div className="games">
              <div className="games-filters">
                <GameFilter text="Fase de Grupos - 1ª Div" />
                <GameFilter text="Fase de Grupos - 2ª Div" />
                <GameFilter text="Playoffs" />
              </div>
              <h3 className="games-header">Grupo A</h3>
              <div className="games-list">
                <Row className="row-game">
                  <Col lg={4}>
                    <Game gameDay="Jornada 1" data="31/02" result="3 - 0" />
                  </Col>
                  <Col lg={4}>
                    <Game gameDay="Jornada 2" data="31/02" result="3 - 0" />
                  </Col>
                  <Col lg={4}>
                    <Game gameDay="Jornada 3" data="31/02" result="VS" />
                  </Col>
                </Row>
                <Row className="row-game">
                  <Col lg={4}>
                    <Game gameDay="Jornada 4" data="31/02" result="VS" />
                  </Col>
                  <Col lg={4}>
                    <Game gameDay="Jornada 5" data="31/02" result="VS" />
                  </Col>
                  <Col lg={4}>
                    <Game gameDay="Jornada 6" data="31/02" result="VS" />
                  </Col>
                </Row>
              </div>
            </div>
          )}
          {params.view === "classification" && (
            <>
              <SportClassification />
              <SportBracket />
            </>
          )}
          {params.view === "team" && <SportTeam />}
        </div>
      </div>
    </>
  );
};

export default SportModality;
