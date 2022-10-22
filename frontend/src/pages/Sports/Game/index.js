import React, { useState } from "react";
import { Row, Col } from "react-bootstrap";
import Image from "react-bootstrap/Image";
import nei from "../img/nei.png";
import "./index.css";

const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(
  process.env.REACT_APP_ANIMATION_INCREMENT
);

const Game = (props) => {
  return (
    <>
      <Row className="game">
        <Col className="game-data" lg={12}>
          <h3>{props.data}</h3>
        </Col>
        <Col>
          <Image
            src={nei}
            rounded
            fluid
            className="slideUpFade logo"
            style={{
              animationDelay: animationBase + animationIncrement * 0 + "s",
            }}
          ></Image>
          <p>Eng. Informática</p>
        </Col>
        <Col className="game-result" lg={2}>
          <h4>3 - 0</h4>
        </Col>
        <Col lg={5}>
          <Image
            src={nei}
            rounded
            fluid
            className="slideUpFade logo"
            style={{
              animationDelay: animationBase + animationIncrement * 0 + "s",
            }}
          ></Image>
          <p>Eng. Computacional</p>
        </Col>
      </Row>
    </>
  );
};

export default Game;
