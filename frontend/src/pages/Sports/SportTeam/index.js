import React from "react";

import equipa from "../img/equipa.jpg";
import { Row, Col } from "react-bootstrap";
import Image from "react-bootstrap/Image";

import SquadCard from "../../../components/SquadCards"


import "./index.css";

const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(
  process.env.REACT_APP_ANIMATION_INCREMENT
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
            <h2 className="mb-5 slideUpFade">Plantel</h2>
        </div>
        <div>
        <Col lg={2} md={8} sm={12}>
            <SquadCard
                image={equipa}
                title="Marco António"
            ></SquadCard>
        </Col>
        </div>

    </>
  );
};

export default SportTeam;
