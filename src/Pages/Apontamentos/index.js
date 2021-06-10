import React, { useState, useEffect } from 'react';
import { Row, Col, Tab, Nav, Accordion } from 'react-bootstrap';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTh, faThList } from '@fortawesome/free-solid-svg-icons';
import ListViewItem from './ListViewItem';
import GridViewItem from './GridViewItem';
import "./index.css";
import PageNav from '../../Components/PageNav';
import Filters from "../../Components/Filters"
import FilterSelect from "../../Components/Filters/FilterSelect";

const Apontamentos = () => {

    // for testing purposes
    const test_data = [
        {
            "id": "65",
            "name": "Resumos ALGA 2018/2019 (zip)",
            "subjectShort": "ALGA",
            "subjectName": "Álgebra Linear e Geometria Analítica",
            "summary": "1",
            "tests": "0",
            "bibliography": "0",
            "slides": "0",
            "exercises": "0",
            "projects": "0",
            "notebook": "0"
        },
        {
            "id": "51",
            "name": "Exercícios 2018/19",
            "subjectShort": "EF",
            "subjectName": "Elementos de Fisíca",
            "summary": "0",
            "tests": "1",
            "bibliography": "0",
            "slides": "0",
            "exercises": "1",
            "projects": "0",
            "notebook": "0"
        },
        {
            "id": "50",
            "name": "Resumos EF 2018/2019 (zip)",
            "subjectShort": "EF",
            "subjectName": "Elementos de Fisíca",
            "summary": "0",
            "tests": "0",
            "bibliography": "0",
            "slides": "0",
            "exercises": "1",
            "projects": "0",
            "notebook": "0"
        },
        {
            "id": "28",
            "name": "Resumos POO 2018/2019 (zip)",
            "subjectShort": "POO",
            "subjectName": "Programação Orientada a Objetos",
            "summary": "1",
            "tests": "1",
            "bibliography": "0",
            "slides": "0",
            "exercises": "1",
            "projects": "0",
            "notebook": "0"
        },
        {
            "id": "16",
            "name": "Preparação para Exame Final de MAS",
            "subjectShort": "MAS",
            "subjectName": "Modelação e Análise de Sistemas",
            "summary": "1",
            "tests": "0",
            "bibliography": "0",
            "slides": "0",
            "exercises": "0",
            "projects": "0",
            "notebook": "0"
        },
        {
            "id": "6",
            "name": "Resoluções 18/19",
            "subjectShort": "FP",
            "subjectName": "Fundamentos de Programação",
            "summary": "0",
            "tests": "0",
            "bibliography": "0",
            "slides": "0",
            "exercises": "1",
            "projects": "0",
            "notebook": "0"
        },
        {
            "id": "85",
            "name": "Resumos MD 2018/2019 (zip)",
            "subjectShort": "MD",
            "subjectName": "Matemática Discreta",
            "summary": "1",
            "tests": "0",
            "bibliography": "0",
            "slides": "0",
            "exercises": "0",
            "projects": "0",
            "notebook": "0"
        },
        {
            "id": "75",
            "name": "Resumos Cálculo II 2018/2019 (zip)",
            "subjectShort": "C2",
            "subjectName": "Cálculo II",
            "summary": "1",
            "tests": "0",
            "bibliography": "0",
            "slides": "0",
            "exercises": "0",
            "projects": "0",
            "notebook": "0"
        },
        {
            "id": "4",
            "name": "Resumos FP 2018/2019 (zip)",
            "subjectShort": "FP",
            "subjectName": "Fundamentos de Programação",
            "summary": "1",
            "tests": "1",
            "bibliography": "0",
            "slides": "0",
            "exercises": "1",
            "projects": "0",
            "notebook": "0"
        }
    ];


    // useStates and other variables
    const [data, setData] = useState([]);
    const [gridItems, setGridItems] = useState([]);
    const [listItems, setListItems] = useState([]);
    const [filters, setFilters] = useState([]);
    const [activeFilters, setActiveFilters] = useState([]);
    const [selection, setSelection] = useState([]);  
    const [showData, setShowData] = useState([]);  

    // API stuff, filters, etc...
    // ...
    useEffect( () => {
        setData(test_data);
        setShowData(test_data);
        setFilters(
            [
                {'filter': 'Bibliography'},
                {'filter': 'Exercises'},
                {'filter': 'Notebook'},
                {'filter': 'Projects'},
                {'filter': 'Slides'},
                {'filter':'Summary'}, 
                {'filter': 'Tests'}
            ]
        )
    }, []);
    
    useEffect( () => {
        // modify props as needed
        setGridItems(showData.map( d => <GridViewItem data={d}></GridViewItem>));
        setListItems(showData.map( d => <ListViewItem data={d}></ListViewItem>));
    }, [showData])

    useEffect( () => {
        let datas = [];
        data.map(d => {
            activeFilters.forEach(f => {
                if (d[f.toLowerCase()] == "1" && !datas.includes(d)) 
                    datas.push(d); 
            })
        });
        
        setShowData(datas);
    }, [activeFilters])

    useEffect( () => {
        setActiveFilters(filters.map(content => content.filter));
    }, [filters])
    

    return (
        <div>
            <Row>
                <Col md="3">
                    <FilterSelect
                        accordion={true}
                        filterList={filters}
                        activeFilters={activeFilters}
                        setActiveFilters={setActiveFilters}
                        className="mb-5"
                        btnClass="mr-2"
                    />
                    {
                        //<div style={{backgroundColor:"darkcyan", height:"600px",width:"100%"}}>Filters and search</div>
                    }
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
                            <Nav.Item className="mr-auto"><Nav.Link eventKey="list" className="h5">
                                <FontAwesomeIcon icon={ faThList } />
                                <span className="ml-3">List</span>
                            </Nav.Link></Nav.Item>
                            <PageNav page={1} total={3} handler={()=>{console.log("handle")}}></PageNav>
                        </Nav>

                        <Tab.Content>
                            <Tab.Pane eventKey="grid">
                                {gridItems}
                            </Tab.Pane>
                            <Tab.Pane eventKey="list">
                                {listItems}
                            </Tab.Pane>
                        </Tab.Content>
                    </Tab.Container>
                </Col>
            </Row>
        </div>
    );
}

export default Apontamentos;