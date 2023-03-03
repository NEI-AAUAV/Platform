import React, { useState, useEffect } from "react";

import Typist from "react-typist";
import SideBar from "./components/SideBar";
import TopBar from "./components/TopBar";
import { Row, Col } from "react-bootstrap";
import Game from './components/Game';

import "./index.css";
import GameFilter from "./components/GameFilter";


const Sports = () => {

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
          <TopBar />
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
                  <Game gameDay="Jornada 2" data="31/02" result="3 - 0"/>
                </Col>
                <Col lg={4}>
                  <Game gameDay="Jornada 3" data="31/02" result="VS"/>
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
          <div className="games">
            <h3 className="games-header">Grupo B</h3>
            <p className="games-day">Jornada 1</p>
            <div>
              <Row className="row-game">
                <Col lg={4}>
                  <Game data="31/02" result="VS" />
                </Col>
                <Col lg={4}>
                  <Game data="31/02" result="VS" />
                </Col>
                <Col lg={4}>
                  <Game data="31/02" result="VS" />
                </Col>
              </Row>
              <Row className="row-game">
                <Col lg={4}>
                  <Game data="31/02" result="VS" />
                </Col>
                <Col lg={4}>
                  <Game data="31/02" result="VS" />
                </Col>
                <Col lg={4}>
                  <Game data="31/02" result="VS" />
                </Col>
              </Row>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Sports;
