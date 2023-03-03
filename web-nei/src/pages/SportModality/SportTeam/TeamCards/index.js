import React from 'react';

import Col from 'react-bootstrap/Col';
import Row from 'react-bootstrap/Row';

import player from "../../img/dani.jpeg";

import "./index.css";

const Player = () => {
    return (
      <Row  xs={1} sm={3} md={4} lg={5} xl={6} className=" Card_Team" >
      {Array.from({ length: 8 }).map((_, idx) => (
        <Col className="cardBody">
          <div  className="teamCardsImg"  style={{backgroundImage:`url(${player})`}}></div>
          <div className='PlayerName'>
            <h5>Marco António</h5>
          </div>
        </Col>
      ))}
      </Row>
    );
}


export default Player;

