import React from 'react';
import {Button} from 'react-bootstrap'
import { Container, Row, Col } from 'react-bootstrap';

import "./Year.css"


const Year = ({year, func}) => {
    return (
        <div>
            <Container>
                <Col xs={11} lg={10} style={{textAlign: "center", marginBottom: 40}}>
                    <p onClick={() => func(year)}>{year}</p>
                </Col>
            </Container>
            
        </div>
    )
}

export default Year;