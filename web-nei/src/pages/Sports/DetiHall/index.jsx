import React from "react";
import { Row, Col } from "react-bootstrap";
import Image from "react-bootstrap/Image";
/* import nei from "../img/nei.png"; */
import "./index.css";

const animationBase = parseFloat(import.meta.env.VITE_ANIMATION_BASE);
const animationIncrement = parseFloat(
  import.meta.env.VITE_ANIMATION_INCREMENT
);

const DetiHall = (props) => {
  return (
    <>
      <Row className="hallContainer">
        <Col className="hallHeader" lg={12}>
          <h3>DETI HALL</h3>
        </Col>
        <Row className="trophies">
          <Col className="trophy">
            <Image
              src={
                "https://splash.stylemixthemes.com/soccer/wp-content/uploads/sites/3/2017/01/cup_5.png"
              }
              rounded
              fluid
              className="slideUpFade logo"
              style={{
                animationDelay: animationBase + animationIncrement * 0 + "s",
              }}
            ></Image>
            <p className="trophy-class">2º Lugar Futsal</p>
            <p className="trophy-year">2019/2020</p>
          </Col>
          <Col className="trophy">
            <Image
              src={
                "https://splash.stylemixthemes.com/soccer/wp-content/uploads/sites/3/2017/01/cup_5.png"
              }
              rounded
              fluid
              className="slideUpFade logo"
              style={{
                animationDelay: animationBase + animationIncrement * 0 + "s",
              }}
            ></Image>
            <p className="trophy-class">2º Lugar Futsal</p>
            <p className="trophy-year">2019/2020</p>
          </Col>
          <Col className="trophy">
            <Image
              src={
                "https://splash.stylemixthemes.com/soccer/wp-content/uploads/sites/3/2017/01/cup_5.png"
              }
              rounded
              fluid
              className="slideUpFade logo"
              style={{
                animationDelay: animationBase + animationIncrement * 0 + "s",
              }}
            ></Image>
            <p className="trophy-class">2º Lugar Futsal</p>
            <p className="trophy-year">2019/2020</p>
          </Col>
          <Col className="trophy">
            <Image
              src={
                "https://splash.stylemixthemes.com/soccer/wp-content/uploads/sites/3/2017/01/cup_5.png"
              }
              rounded
              fluid
              className="slideUpFade logo"
              style={{
                animationDelay: animationBase + animationIncrement * 0 + "s",
              }}
            ></Image>
            <p className="trophy-class">2º Lugar Futsal</p>
            <p className="trophy-year">2019/2020</p>
          </Col>
          <Col className="trophy">
            <Image
              src={
                "https://splash.stylemixthemes.com/soccer/wp-content/uploads/sites/3/2017/01/cup_5.png"
              }
              rounded
              fluid
              className="slideUpFade logo"
              style={{
                animationDelay: animationBase + animationIncrement * 0 + "s",
              }}
            ></Image>
            <p className="trophy-class">2º Lugar Futsal</p>
            <p className="trophy-year">2019/2020</p>
          </Col>
          <Col className="trophy">
            <Image
              src={
                "https://splash.stylemixthemes.com/soccer/wp-content/uploads/sites/3/2017/01/cup_5.png"
              }
              rounded
              fluid
              className="slideUpFade logo"
              style={{
                animationDelay: animationBase + animationIncrement * 0 + "s",
              }}
            ></Image>
            <p className="trophy-class">2º Lugar Futsal</p>
            <p className="trophy-year">2019/2020</p>
          </Col>
        </Row>
      </Row>
    </>
  );
};

export default DetiHall;
