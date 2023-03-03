import React, { useState, useEffect } from "react";
import Carousel from "react-bootstrap/Carousel";
import { Row, Col } from "react-bootstrap";
import Image from "react-bootstrap/Image";
import TextList from "../../components/TextList";
/* import Tabs from "../../components/Tabs/index.js"; */
import Game from "./Game";
import img1 from "./img/unknown.png";
import img2 from "./img/unknown2.png";
import img3 from "./img/unknown3.png";
import equipa from "./img/equipa.jpg";
import { useNavigate } from "react-router";

import { ReactComponent as Futsal } from "../../assets/icons/tacaua/high_contrast/voleibol.svg";

import Typist from "react-typist";

import "./index.css";
/* import SportTable from "./SportTable"; */
import DetiHall from "./DetiHall";

const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(
  process.env.REACT_APP_ANIMATION_INCREMENT
);

const Sports = () => {
  const [tabIndicator, setTabIndicator] = useState("Andebol");
  const [tabIndicatorSex, setTabIndicatorSex] = useState("Masculino");
  /* const [img, setImg] = useState(null); */
  const [anos /* , setAnos */] = useState([]);
  /* const [selectedYear, setSelectedYear] = useState(); */
  const [data, setData] = useState([]);
  const navigate = useNavigate();

  /*setImg(<Image
        src={equipa} rounded fluid
        className="slideUpFade"
        style={{
            animationDelay: animationBase + animationIncrement * 0 + "s",
            "marginBottom": 50
        }}
    />);*/

  useEffect(() => {
    // fetch(process.env.REACT_APP_API + "/sports/modalities")
    //   .then(response => response.json())
    //   .then((response) => {
    //     if ('data' in response) {
    //       setData(response["data"]);
    //       //console.log(data);
    //     }
    //   });
  }, []);

  /*

  useEffect(() => {

    setImg(<Image
      src={equipa}
      rounded
      fluid
      className="slideUpFade"
      style={{
        animationDelay: animationBase + animationIncrement * 0 + "s",
        marginBottom: 50,
        marginTop: 50,
      }}
    />)
  }, [tabIndicator, tabIndicatorSex]);*/

  function changeTab(value) {
    setTabIndicator(value);
  }

  /* function loadTab() {
    let result1 = [];
    //let result2 = [];
    let bothGenders = false;
    let arr = [];
    let info = new Map();

    for (let i = 0; i < data.length; i++) {
      const map = new Map(Object.entries(data[i]));
      if (arr.includes(map.get("name"))) {
        bothGenders = true;
        info.set(map.get("name"), true);
      } else {
        arr.push(map.get("name"));
        bothGenders = false;
      }
      if (!bothGenders) {
        if (tabIndicator === map.get("name"))
          result1.push(<li class="act">{map.get("name")}</li>);
        else
          result1.push(
            <li onClick={() => changeTab(map.get("name"))}>
              {map.get("name")}
            </li>
          );
      }
    }

    window.info = info;

    return <>{result1}</>;
  }

  function loadGenderTab() {
    let result = [];

    window.info.forEach((value, key) => {
      if (value && key === tabIndicator) {
        if (tabIndicatorSex === "Masculino") {
          result.push(<li class="act">Masculino</li>);
          result.push(
            <li onClick={() => setTabIndicatorSex("Feminino")}>Feminino</li>
          );
        } else {
          result.push(
            <li onClick={() => setTabIndicatorSex("Masculino")}>Masculino</li>
          );
          result.push(<li class="act">Feminino</li>);
        }
      }
    });

    return <>{result}</>;
  } */

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
        <Carousel fade style={{ marginBottom: "3rem" }}>
          <Carousel.Item interval={2000}>
            <div className="carousel-image-wrapper">
              <img
                className="d-block w-100"
                src={img1}
                alt="Carousel One"
                style={{ height: "100%", objectFit: "cover" }}
              />
            </div>
          </Carousel.Item>
          <Carousel.Item interval={2000}>
            <div className="carousel-image-wrapper">
              <img
                className="d-block w-100"
                src={img2}
                alt="Carousel One"
                style={{ height: "100%", objectFit: "cover" }}
              />
            </div>
          </Carousel.Item>
          <Carousel.Item interval={2000}>
            <div className="carousel-image-wrapper">
              <img
                className="d-block w-100"
                src={img3}
                alt="Carousel One"
                style={{ height: "100%", objectFit: "cover" }}
              />
            </div>
          </Carousel.Item>
        </Carousel>
      </div>
      {anos}
      <div style={{ marginTop: "5rem" }}>
        <h3 className="mb-5 text-center slideUpFade">Modalidades</h3>
      </div>
      {/*  <div class="lista">
        <ul className="slideUpFade">{loadTab()}</ul>
      </div>
      <div class="gender-list">
        <ul className="slideUpFade">{loadGenderTab()}</ul>
      </div> */}

      <div className="d-flex flex-column flex-wrap team-wrapper" y>
        <Row className="modalidades">
          <div className="modalidade" onClick={() => navigate("/taca-ua/1")}>
            <Image
              src={equipa}
              alt=""
              rounded
              className="slideUpFade"
              style={{
                animationDelay: animationBase + animationIncrement * 0 + "s",
                objectFit: "cover",
              }}
              width={350}
              height={200}
            />
            <div className="gradient">
              <p className="modalidadeText">Futsal Masculino</p>
              <Futsal className="icon" />
            </div>
          </div>
          <div className="modalidade" onClick={() => navigate("/taca-ua/1")}>
            <Image
              src={equipa}
              alt=""
              rounded
              className="slideUpFade"
              style={{
                animationDelay: animationBase + animationIncrement * 0 + "s",
                objectFit: "cover",
              }}
              width={350}
              height={200}
            />
            <div className="gradient">
              <p className="modalidadeText">Futsal Masculino</p>
              <Futsal className="icon" />
            </div>
          </div>
          <div className="modalidade" onClick={() => navigate("/taca-ua/1")}>
            <Image
              src={equipa}
              alt=""
              rounded
              className="slideUpFade"
              style={{
                animationDelay: animationBase + animationIncrement * 0 + "s",
                objectFit: "cover",
              }}
              width={350}
              height={200}
            />
            <div className="gradient">
              <p className="modalidadeText">Futsal Masculino</p>
              <Futsal className="icon" />
            </div>
          </div>
          <div className="modalidade" onClick={() => navigate("/taca-ua/1")}>
            <Image
              src={equipa}
              alt=""
              rounded
              className="slideUpFade"
              style={{
                animationDelay: animationBase + animationIncrement * 0 + "s",
                objectFit: "cover",
              }}
              width={350}
              height={200}
            />
            <div className="gradient">
              <p className="modalidadeText">Futsal Masculino</p>
              <Futsal className="icon" />
            </div>
          </div>
          <div className="modalidade" onClick={() => navigate("/taca-ua/1")}>
            <Image
              src={equipa}
              alt=""
              rounded
              className="slideUpFade"
              style={{
                animationDelay: animationBase + animationIncrement * 0 + "s",
                objectFit: "cover",
              }}
              width={350}
              height={200}
            />
            <div className="gradient">
              <p className="modalidadeText">Futsal Masculino</p>
              <Futsal className="icon" />
            </div>
          </div>
        </Row>

        <Row className="games-section">
          <Col className="column">
            <h3 className="column-header">Resultados</h3>
            <Game data="31/02"></Game>
            <Game data="31/02"></Game>
            <Game data="31/02"></Game>
          </Col>
          <Col className="column">
            <h3 className="column-header">Próximos Jogos</h3>
            <Game data="31/02"></Game>
            <Game data="31/02"></Game>
          </Col>
        </Row>

        <Row className="games-section">
          <DetiHall />
        </Row>
      </div>
    </>
  );
};

export default Sports;
