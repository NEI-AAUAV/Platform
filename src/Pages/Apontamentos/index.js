import React, { useState, useEffect } from 'react';
import { Row, Col, Tab, Nav, Accordion, Form } from 'react-bootstrap';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTh, faThList } from '@fortawesome/free-solid-svg-icons';
import ListView from './ListView';
import GridView from './GridView';
import "./index.css";
import PageNav from '../../Components/PageNav';
import Filters from "../../Components/Filters";
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

    // varName, setVarname --> used to save the group
    // selVarName, setVarName --> used to save the selected element of the group

    const [subjects, setSubjects] = useState([]); // todos os subjects
    const [selectedSubject, setSelectedSubject] = useState("");
    const [subjectName, setSubjectName] = useState("");
    const [years, setYears] = useState("");
    const [selYear, setSelYear] = useState("");
    //const [selSemester, setSelSemester] = useState(""); // Will we use this?
    const [student, setStudents] = useState("");
    const [selStudent, setSelStudent] = useState("");
    const [teachers, setTeachers] = useState("");
    const [selTeacher, setSelTeacher] = useState("");
    const [pageNumber, setPageNumber] = useState(1);
    const [selPage, setSelPage] = useState(1);

    const fetchPage = (p_num) => {
        console.log("currPage: " + selPage + ", new_page: " + p_num);

        setSelPage(p_num);
    }

    useEffect( () => {
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
    }, [])


    useEffect( () => {
        
        //console.log("mh")
        
        // extraVarName --> base used to concatenate and compare the optionals of every fetch
        var extraYear = selYear == "" ? "" : "schoolYear=" + selYear + "&";
        var extraSubj = selectedSubject == "" ? "" : "subject=" + selectedSubject + "&";
        var extraStud = selStudent == "" ? "" : "student=" + selStudent + "&";
        var extraTeacher = selTeacher == "" ? "" : "teacher=" + selTeacher + "&";
        var extraCategory = "";

        for (var i=0; i<activeFilters.length; i++) {
            extraCategory += "category[]=" + activeFilters[i].toLowerCase() + "&";
        }
        

        // fullVarName --> sum of optionals of every fetch
        var fullTeacher = "";

        if (extraYear != "" || extraSubj != "" || extraStud != "") {
            fullTeacher = "?";
            fullTeacher += extraYear;
            fullTeacher += extraSubj;
            fullTeacher += extraStud;
            fullTeacher = fullTeacher.substring(0,fullTeacher.length-1); // ignore the last '&'
        }

        var fullYear = "";

        if (extraTeacher != "" || extraSubj != "" || extraStud != "") {
            fullYear = "?";
            fullYear += extraTeacher;
            fullYear += extraSubj;
            fullYear += extraStud;
            fullYear = fullYear.substring(0,fullYear.length-1); // ignore the last '&'
        }

        var fullSubj = "";

        if (extraTeacher != "" || extraYear != "" || extraStud != "") {
            fullSubj = "?";
            fullSubj += extraYear;
            fullSubj += extraStud;
            fullSubj += extraTeacher;
            fullSubj = fullSubj.substring(0,fullSubj.length-1); // ignore the last '&'
        }

        var fullStud = "";

        if (extraTeacher != "" || extraSubj != "" || extraYear != "" ) {
            fullStud = "?";
            fullStud += extraTeacher;
            fullStud += extraSubj;
            fullStud += extraYear;
            fullStud = fullStud.substring(0,fullStud.length-1); // ignore the last '&'
        }

        if (extraCategory.length == 0) {
            setData([]);
        }
        else {
            var fullNotes = "?page="+selPage+"&";

            fullNotes += extraTeacher;
            fullNotes += extraSubj;
            fullNotes += extraStud;
            fullNotes += extraCategory;
            fullNotes += extraYear;
            fullNotes = fullNotes.substring(0,fullNotes.length-1); // ignore the last '&'


            fetch(process.env.REACT_APP_API + "/notes" + fullNotes)
            .then((response) => response.json())
            .then((response) => {            
                setData(response.data)
                setPageNumber(response.page.pagesNumber);

            })
        }

        //console.log("extra: "+ extra);

        fetch(process.env.REACT_APP_API + "/notes/years" + fullYear)
        .then((response) => response.json())
        .then((response) => {
            setYears(response.data.map( (year) => 
                <option value={year.id} selected={year.id == selYear}>{year.yearBegin + "-" + year.yearEnd}</option>
            ))
        })
        
        fetch(process.env.REACT_APP_API + "/notes/subjects" + fullSubj)
        .then((response) => response.json())
        .then((response) => {

            var subjs = response.data.map(s => <option value={s.paco_code} selected={s.paco_code == selectedSubject}>{s.short}</option>)
            setSubjects(subjs);
        })

        //console.log("subjects: "+subjects)
        //console.log("extra: "+extraSubj)
        fetch(process.env.REACT_APP_API + "/notes/students" + fullStud)
        .then((response) => response.json())
        .then((response) => {            
            setStudents(response.data.map(s => <option value={s.id} selected={s.id == selStudent}>{s.name}</option>))
            
        })


        fetch(process.env.REACT_APP_API + "/notes/teachers" + fullTeacher)
        .then((response) => response.json())
        .then((response) => {            
            setTeachers(response.data.map(s => <option value={s.id} selected={s.id == selTeacher}>{s.name}</option>));
        })

    }, [activeFilters, selectedSubject, selStudent, selYear, selPage, selTeacher]);
    

    useEffect( () => {
        setActiveFilters(filters.map(content => content.filter));
    }, [filters])
    
    return (
        <div>
            <Row>
                <Col md="3">
                    <Form>
                        {/*
                            <Form.Group>
                            <Form.Control 
                                type="text" 
                                placeholder="Name"
                                onChange={ (e) => setSubjectName(e.target.value)}
                            />
                            </Form.Group>
                        */}
                        
                        <Form.Group>
                            <Form.Control 
                                as="select" 
                                onChange={ (e) => setSelYear(e.target.value)}
                            >
                                <option value="">Ano Letivo...</option>
                                {years}
                            </Form.Control>
                        </Form.Group>
                        {/*
                            <Form.Group>
                            <Form.Control 
                                as="select" 
                                onChange={ (e) => setSelSemester(e.target.value)}
                            >
                                <option>Semester...</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                            </Form.Control>
                        </Form.Group>
                        */}
                        

                        <Form.Group>
                            <Form.Control 
                                as="select" 
                                onChange={ (e) => setSelectedSubject(e.target.value)}
                                defaultValue={selectedSubject}
                            >
                                <option value="">Cadeira...</option>
                                {subjects}
                            </Form.Control>
                        </Form.Group>

                        <Form.Group>
                            <Form.Control 
                                as="select" 
                                onChange={ (e) => setSelStudent(e.target.value)}
                                defaultValue={selStudent}
                            >
                                <option value="">Autor...</option>
                                {student}
                            </Form.Control>
                        </Form.Group>

                        <Form.Group>
                            <Form.Control 
                                as="select" 
                                onChange={ (e) => setSelTeacher(e.target.value)}
                            >
                                <option value="">Professor...</option>
                                {teachers}
                            </Form.Control>
                        </Form.Group>
                    </Form>
                    
                    <FilterSelect
                        accordion={true}
                        filterList={filters}
                        activeFilters={activeFilters}
                        setActiveFilters={setActiveFilters}
                        className="mb-5"
                        btnClass="mr-2"
                    />
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
                            <PageNav page={selPage} total={pageNumber} handler={fetchPage}></PageNav>
                        </Nav>

                        <Tab.Content>
                            <Tab.Pane eventKey="grid">
                                <GridView data={data}></GridView>
                            </Tab.Pane>
                            <Tab.Pane eventKey="list">
                                <ListView data={data}></ListView>
                            </Tab.Pane>
                        </Tab.Content>
                    </Tab.Container>
                </Col>
            </Row>
        </div>
    );
}

export default Apontamentos;