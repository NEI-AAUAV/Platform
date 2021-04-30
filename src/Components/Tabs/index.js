import React, { useEffect, useState } from "react";
import {Button} from 'react-bootstrap'
import { Container, Row, Col } from 'react-bootstrap';
import Tab from './Tab/index.js'

import "./index.css"



const Tabs = ({tabs, _default, onChange}) => {

    const [selectedElement, setSelectedElement] = useState(null);

    const tab = tabs.map(tab => <Tab func={onChange} val={tab} 
        selectedElement={selectedElement} update={setSelectedElement}/>)
    
    useEffect(() => {
        setSelectedElement(_default)
    }, [_default])
    

    return (
        <Container>
            <Row className="justify-content-center">
                {tab}
            </Row>
        </Container>
    )
}

export default Tabs;