import React, { useEffect, useState } from "react";
import {Button} from 'react-bootstrap'
import { Container, Row, Col } from 'react-bootstrap';
import Tab from './Tab/index.js'

import "./index.css"

/*
Tabs é um componente em que é um "pseudo navbar" para acessar um conjunto de valores, dado em um array.

Props:
tabs -> array que contém os valores das quais queres navegar.
_default -> valor que começa selecionado.
onChange -> função setState que altera o valor de um state.

*/

const Tabs = ({tabs, _default, onChange}) => {

    const [selectedElement, setSelectedElement] = useState(null);

    const tab = tabs.map(tab => <Tab func={onChange} val={tab} 
        selectedElement={selectedElement} update={setSelectedElement}/>)
    
    useEffect(() => {
        setSelectedElement(_default)
    }, [_default])
    

    return (
        <Container className="tab-container">
            <Row className="justify-content-center">
                {tab}
            </Row>
        </Container>
    )
}

export default Tabs;