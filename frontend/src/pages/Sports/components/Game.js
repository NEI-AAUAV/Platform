import './Game.css' 
import React, { useState } from "react";
import { Row, Col } from "react-bootstrap";
import Image from "react-bootstrap/Image";
import nei from "../img/nei.png";

const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(
  process.env.REACT_APP_ANIMATION_INCREMENT
);

const Game = (props) => {
    return (
        <>
            <Row style={{paddingBottom: '1rem', margin: 0, 
                        animationDelay:
                                animationBase + animationIncrement * 0 + "s"}} className="slideUpFade game">
                <Col className="game-number" lg={12}>
                    <p>{props.gameDay}</p>
                </Col>
                <Col className="game-data" lg={12}>
                    <h4>{props.data}</h4>
                </Col>
                <Col style={{padding: 0, margin: 0}} lg={4}>
                    <Image
                        src={nei}
                        rounded
                        fluid
                        className="logo"
                    ></Image>
                </Col>
                <Col style={{padding: 0, margin: 0}} className="game-result" lg={4}>
                    <h4>{props.result}</h4>
                </Col>
                <Col style={{padding: 0, margin: 0}} lg={4}>
                    <Image
                        src={nei}
                        rounded
                        fluid
                        className="logo"
                    ></Image>
                </Col>
            </Row>
        </>
    )
}

export default Game;