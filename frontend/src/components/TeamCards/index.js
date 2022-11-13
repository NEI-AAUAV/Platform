import React from 'react';

import Col from 'react-bootstrap/Col';
import Row from 'react-bootstrap/Row';

import player from "../../pages/Sports/img/unknown2.png";

import "./index.css";

const Player = () => {
    return (
      <Row xsm={2} md={3} lg={6} className=" Card_Team" >
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

