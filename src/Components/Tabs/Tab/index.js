import React from 'react';
import {Button} from 'react-bootstrap'
import { Container, Row, Col } from 'react-bootstrap';

import "./index.css"

/*
Tab é um componente em que é um "pseudo navbar" para acessar um conjunto de valores, dado em um array.


*/


const Tab = ({val, func, selectedElement, update}) => {
    //console.log("selEl = "+selectedElement);
    //console.log("val = "+val);
    return (
            <div className={val == selectedElement ? "selected" : ""}>
                <Col xs={12} lg={12} className="tabDiv">
                    <p className="tabItem" 
                    onClick={(el) =>{ func(val); update(val)}}>{val}</p>
                </Col>
            </div>
    )
}

export default Tab;