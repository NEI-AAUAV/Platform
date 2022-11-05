import React from 'react';

import Col from 'react-bootstrap/Col';
import Row from 'react-bootstrap/Row';

import player from "../../pages/Sports/img/unknown2.png";

import "./index.css";

//{Array.from({ length: 5 }).map((_, idx) => ()

const Player = () => {
    return (
      <Row xs={2} md={5} className="g-6 Card_Team" >
      
        <Col>
          <div className="cardBody"> 
            <div  className="teamCardsImg"  style={{backgroundImage:`url(${player})`}}></div>
              <div className='PlayerName'>
                <h5>Marco António</h5>
              </div>
          </div>
        </Col>

      </Row>
    );
}


export default Player;

