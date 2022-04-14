import React, { useState } from "react";
import Carousel from "react-bootstrap/Carousel";
import { Row, Col } from "react-bootstrap";
import Image from "react-bootstrap/Image";
import TextList from "../../Components/TextList";
import Game from './Game/Game';
import img1 from "./img/unknown.png";
import img2 from "./img/unknown2.png";
import img3 from "./img/unknown3.png";
import equipa from "./img/equipa.jpg";

import Typist from "react-typist";

import "./index.css";

const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(
  process.env.REACT_APP_ANIMATION_INCREMENT
);

const Sports = () => {
  const [tabIndicator, setTabIndicator] = useState("Andebol");
  const [img, setImg] = useState(null);

  /*setImg(<Image
        src={equipa} rounded fluid
        className="slideUpFade"
        style={{
            animationDelay: animationBase + animationIncrement * 0 + "s",
            "marginBottom": 50
        }}
    />);*/

  function changeTab(value) {
    setTabIndicator(value);
  }

  return (
    <>
      <div className="d-flex flex-column flex-wrap">
        <h2 className="mb-5 text-center">
          <Typist>Taça UA</Typist>
        </h2>
      </div>
      <div
        className="slideUpFade"
        style={{ animationDelay: animationBase + animationIncrement }}
      >
        <Carousel fade>
          <Carousel.Item interval={2000}>
            <div className="image-wrapper">
              <img className="d-block w-100" src={img1} alt="Carousel Item" />
            </div>
          </Carousel.Item>
          <Carousel.Item interval={2000}>
            <div className="image-wrapper">
              <img className="d-block w-100" src={img2} alt="Carousel Item" />
            </div>
          </Carousel.Item>
          <Carousel.Item interval={2000}>
            <div className="image-wrapper">
              <img className="d-block w-100" src={img3} alt="Carousel Item" />
            </div>
          </Carousel.Item>
        </Carousel>
      </div>
      <div style={{ marginTop: "50px" }}>
        <h3 className="mb-5 text-center slideUpFade">Modalidades</h3>
      </div>
      <div class="lista">
        <ul className="slideUpFade">
          {tabIndicator === "Andebol" ? (
            <li class="act">Andebol</li>
          ) : (
            <li onClick={() => changeTab("Andebol")}>Andebol</li>
          )}
          {tabIndicator === "Futebol" ? (
            <li class="act">Futebol</li>
          ) : (
            <li onClick={() => changeTab("Futebol")}>Futebol</li>
          )}
          {tabIndicator === "Voleibol" ? (
            <li class="act">Voleibol</li>
          ) : (
            <li onClick={() => changeTab("Voleibol")}>Voleibol</li>
          )}
          {tabIndicator === "Futsal" ? (
            <li class="act">Futsal</li>
          ) : (
            <li onClick={() => changeTab("Futsal")}>Futsal</li>
          )}
          {tabIndicator === "Basquetebol" ? (
            <li class="act">Basquetebol</li>
          ) : (
            <li onClick={() => changeTab("Basquetebol")}>Basquetebol</li>
          )}
        </ul>
      </div>

      <div className="d-flex flex-column flex-wrap team-wrapper">
        <Row>
          <Image
            src={equipa}
            rounded
            fluid
            className="slideUpFade"
            style={{
              animationDelay: animationBase + animationIncrement * 0 + "s",
              marginBottom: 50,
              marginTop: 50,
            }}
          ></Image>
        </Row>
        <Row>
          <TextList
            colSize={4}
            text="Pedro Monteiro"
            className="slideUpFade"
            style={{
              animationDelay: animationBase + animationIncrement * 0 + "s",
            }}
          />
          <TextList
            colSize={4}
            text="Pedro Monteiro"
            className="slideUpFade"
            style={{
              animationDelay: animationBase + animationIncrement * 0 + "s",
            }}
          />
          <TextList
            colSize={4}
            text="Pedro Monteiro"
            className="slideUpFade"
            style={{
              animationDelay: animationBase + animationIncrement * 0 + "s",
            }}
          />
          <TextList
            colSize={4}
            text="Pedro Monteiro"
            className="slideUpFade"
            style={{
              animationDelay: animationBase + animationIncrement * 0 + "s",
            }}
          />
          <TextList
            colSize={4}
            text="Pedro Monteiro"
            className="slideUpFade"
            style={{
              animationDelay: animationBase + animationIncrement * 0 + "s",
            }}
          />
          <TextList
            colSize={4}
            text="Pedro Monteiro"
            className="slideUpFade"
            style={{
              animationDelay: animationBase + animationIncrement * 0 + "s",
            }}
          />
        </Row>

        <Row className="games-section">
          <Col className="column" lg={6}>
            <h3 className="column-header">Resultados</h3>
            <Game></Game>
            <Game></Game>
            <Game></Game>
          </Col>
          <Col className="column" lg={6}>
            <h3 className="column-header">Próximos Jogos</h3>
            <Game></Game>
            <Game></Game>
          </Col>
        </Row>
      </div>
    </>
  );
};

export default Sports;
