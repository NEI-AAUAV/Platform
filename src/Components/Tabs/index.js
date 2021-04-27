import React, { useEffect } from 'react';
import {Button} from 'react-bootstrap'
import { Container, Row, Col } from 'react-bootstrap';
import Tab from './Tab/index.js'

import "./index.css"


const Tabs = ({tabs, _default, onChange}) => {
    const tab = tabs.map(tab => <Tab func={onChange} val={tab}/>)
    
    useEffect(() => {
        onChange(_default) // Por o valor no default no inicio
    }, [])

    return (
        <Container>
            <Row className="justify-content-center">
                {tab}    
            </Row>
        </Container>
    )
}

export default Tabs;