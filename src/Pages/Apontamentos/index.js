import React, { useState, useEffect } from 'react';
import { Row, Col, Tab, Nav } from 'react-bootstrap';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTh, faThList } from '@fortawesome/free-solid-svg-icons';
import ListViewItem from './ListViewItem';
import "./index.css";

const Apontamentos = () => {

    // useStates and other variables
    // ...

    // API stuff, filters, etc...
    // ...

    return (
        <div>
            <Row>
                <Col md="3">
                    { /* TODO: Filters and search */ }
                    <div style={{backgroundColor:"darkcyan", height:"600px",width:"100%"}}>Filters and search</div>
                </Col>

                {/* The two views are controlled by a bootstrap tabs component,
                 ** using a custom layout. The Nav element contains the buttons that switch
                 ** the views, which are specified in each Tab.Pane element.
                */}
                <Col md="9">
                    <Tab.Container defaultActiveKey="grid">
                        <Nav>
                            <Nav.Item><Nav.Link eventKey="grid" className="h5">
                                <FontAwesomeIcon icon={ faTh } />
                                <span className="ml-3">Grid</span>
                            </Nav.Link></Nav.Item>
                            <Nav.Item><Nav.Link eventKey="list" className="h5">
                                <FontAwesomeIcon icon={ faThList } />
                                <span className="ml-3">List</span>
                            </Nav.Link></Nav.Item>
                        </Nav>

                        <Tab.Content>
                            <Tab.Pane eventKey="grid">
                                Grid View (TODO)
                            </Tab.Pane>
                            <Tab.Pane eventKey="list">
                                List View (TODO)
                            </Tab.Pane>
                        </Tab.Content>
                    </Tab.Container>
                </Col>
            </Row>
        </div>
    );
}

export default Apontamentos;