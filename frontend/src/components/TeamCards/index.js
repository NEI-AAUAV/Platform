import React from 'react';

import Card from 'react-bootstrap/Card';
import Col from 'react-bootstrap/Col';
import Row from 'react-bootstrap/Row';

import equipa from "../../pages/Sports/img/equipa.jpg";

import "./index.css";


const Player = () => {
    return (
        <Row xs={2} md={5} className="g-6">
        {Array.from({ length: 5 }).map((_, idx) => (
          <Col>
            <Card className="cardBody">
                <div  className="teamCardsImg"  >
                    <Card.Img variant="top" src={equipa} />
                </div>
              <Card.Body>
                <Card.Title>Marco António</Card.Title>
              </Card.Body>
            </Card>
          </Col>
        ))}
      </Row>
    );
}


export default Player;

