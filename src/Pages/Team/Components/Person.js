import React from 'react';


import Image from 'react-bootstrap/Image';
import { Container, Row, Col } from 'react-bootstrap';


const Person = ({img,name,description}) => {
    return (
        <div>
            <Container>
                <Row>
                    <Col style={{textAlign: "center"}}>
                        <Image src={img} roundedCircle style={{width: 200}}/>
                        <h3>{name}</h3>
                        <p>{description}</p>
                    </Col>
                </Row>
            </Container>
        </div>
    )
}

export default Person;