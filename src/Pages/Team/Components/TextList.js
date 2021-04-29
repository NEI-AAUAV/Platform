import React from "react"
import { Container, Row, Col } from 'react-bootstrap';
import "./TextList.css"

const TextList = ({text}) => {
    console.log(text)
    return (
    <Container>
            <Col className="mx-auto" style={{textAlign: "center"}}>
                <div className="colName">
                    {text.toUpperCase()}
                </div>
                
            </Col>
    </Container>
    )
}

export default TextList