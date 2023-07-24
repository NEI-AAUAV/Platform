import React from "react";

import equipa from "../img/equipa.jpg";
import { Row } from "react-bootstrap";
import Image from "react-bootstrap/Image";

import "./index.css";
import Player from "./TeamCards";

const animationBase = parseFloat(import.meta.env.VITE_ANIMATION_BASE);
const animationIncrement = parseFloat(
  import.meta.env.VITE_ANIMATION_INCREMENT
);

const SportTeam = () => {

  return (
    <> 
      <div>
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
      </div>

      <div style={{ marginTop: "1rem" }}>  
        <Player/>
      </div>
    </>
  );
};

export default SportTeam;
