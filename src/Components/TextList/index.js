import React from "react"
import { Container, Row, Col } from 'react-bootstrap';
import "./index.css"

/*
TextList: literalmente um prop para facilitar impressões de uma lista de nomes :)
É suposto ser utilizado dentro de um map para cada nome, para assim ficar na formatação igual ao do site.

Props:
text -> nome

*/

const TextList = ({text}) => {
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