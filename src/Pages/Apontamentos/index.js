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
import Details from "./Details";
import Select from "react-select";

const Apontamentos = () => {

    // Grid view selected note
    const [selectedNote, setSelectedNote] = useState(null);


    // useStates and other variables
    const [data, setData] = useState([]);
    const [filters, setFilters] = useState([]);
    const [activeFilters, setActiveFilters] = useState([]);
    const [selection, setSelection] = useState([]);  

    // varName, setVarname --> used to save the group
    // selVarName, setVarName --> used to save the selected element of the group
    // shownVarName --> used to change the value on the ReactSelect to the choosen map

    const [subjects, setSubjects] = useState([]); // todos os subjects
    const [selectedSubject, setSelectedSubject] = useState("");
    const [subjectName, setSubjectName] = useState("");
    const [years, setYears] = useState("");
    const [selYear, setSelYear] = useState("");
    //const [selSemester, setSelSemester] = useState(""); // Will we use this? --> no :P
    const [student, setStudents] = useState("");
    const [selStudent, setSelStudent] = useState("");
    const [teachers, setTeachers] = useState("");
    const [selTeacher, setSelTeacher] = useState("");
    const [pageNumber, setPageNumber] = useState(1);
    const [selPage, setSelPage] = useState(1);

    
    const [shownYear, setShownYear] = useState();
    const [shownSubj, setShownSubj] = useState();
    const [shownAuth, setShownAuth] = useState();
    const [shownTeacher, setShownTeacher] = useState();


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

        // Every time a new call is made to the API, close details
        setSelectedNote(null);
        
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

            //console.log(fullNotes)
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
            /*setYears(response.data.map( (year) => 
                <option value={year.id} selected={year.id == selYear}>{year.yearBegin + "-" + year.yearEnd}</option>
            ))
            */
            if ('data' in response) {
                var arr = response.data.map(year => {

                    const x = { value: year.id, label: year.yearBegin + "-" + year.yearEnd};
                    if (x.value == selYear) 
                        setShownYear(x)
                    return x;
                })

                setYears(arr)
            }


        })
        
        fetch(process.env.REACT_APP_API + "/notes/subjects" + fullSubj)
        .then((response) => response.json())
        .then((response) => {

            //var subjs = response.data.map(s => <option value={s.paco_code} selected={s.paco_code == selectedSubject}>{s.short}</option>)
            //setSubjects(subjs);

            if ('data' in response) {

            
                var arr = response.data.map(subj => {

                    const x = { value: subj.paco_code, label: subj.short };
                    if (x.value == selectedSubject) 
                        setShownSubj(x)
                    return x;
                })

                setSubjects(arr)
            }
        })

        //console.log("subjects: "+subjects)
        //console.log("extra: "+extraSubj)
        fetch(process.env.REACT_APP_API + "/notes/students" + fullStud)
        .then((response) => response.json())
        .then((response) => {            
            //setStudents(response.data.map(s => <option value={s.id} selected={s.id == selStudent}>{s.name}</option>))

            if ('data' in response) {
                var arr = response.data.map(t => {
                    const x = { value: t.id, label: t.name };
                    if (x.value == selStudent) 
                        setShownAuth(x)

                    return x;
                })

                setStudents(arr)
            }
        })


        fetch(process.env.REACT_APP_API + "/notes/teachers" + fullTeacher)
        .then((response) => response.json())
        .then((response) => {            
            //setTeachers(response.data.map(s => <option value={s.id} selected={s.id == selTeacher}>{s.name}</option>));
            if ('data' in response) {
                var arr = response.data.map(t => {
                    const x = { value: t.id, label: t.name };
                    if (x.value == selTeacher) 
                        setShownTeacher(x)

                    return x;
                })

                //console.log(arr)
                setTeachers(arr)
            }
        })

    }, [activeFilters, selectedSubject, selStudent, selYear, selPage, selTeacher]);
    

    useEffect( () => {
        setActiveFilters(filters.map(content => content.filter));
    }, [filters])
    
    return (
        <div>
            <h2 className="text-center">Apontamentos</h2>
            
            <Row className="mt-4">
                <Col lg="3">
                    <Details 
                        note={selectedNote}
                        close={() => setSelectedNote(null)}
                        setSelYear={setSelYear}
                        setSelectedSubject={setSelectedSubject}
                        setSelStudent={setSelStudent}
                        setSelTeacher={setSelTeacher}
                        setSelPage={setSelPage}
                    />

                        <Select 
                            id="teste"
                            className="react-select"
                            options={years}
                            onChange={ (e) => { if (e == null){ setSelYear(""); setShownYear("")} else setSelYear(e.value);}}
                            placeholder="Ano Letivo..."                            
                            isClearable={true}
                            value={shownYear}
                            
                        />

                        <Select 
                            className="react-select"
                            options={subjects}
                            onChange={ (e) =>{ if (e == null){ setSelectedSubject(""); setShownSubj("")} else setSelectedSubject(e.value)}}
                            placeholder="Cadeira..."
                            isClearable={true}
                            value={shownSubj}
                        />

                        <Select 
                            className="react-select"
                            options={student}
                            onChange={ (e) =>{ if (e == null){ setSelStudent(""); setShownAuth("")} else setSelStudent(e.value)}}
                            placeholder="Autor..."
                            isClearable={true}
                            value={shownAuth}
                        />

                        <Select 
                            className="react-select"
                            options={teachers}
                            onChange={ (e) =>{ if (e == null){ setSelTeacher(""); setShownTeacher("")} else setSelTeacher(e.value)}}
                            placeholder="Professor..."
                            isClearable={true}
                            value={shownTeacher}
                        />
                    {/*
                    <Form>
                        
                            <Form.Group>
                            <Form.Control 
                                type="text" 
                                placeholder="Name"
                                onChange={ (e) => setSubjectName(e.target.value)}
                            />
                            </Form.Group>
                        
                        
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

                        

                        {/*
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
                        }
                        

                        

                        {/*
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
                    */
                }
                    
                    <FilterSelect
                        accordion={true}
                        filterList={filters}
                        activeFilters={activeFilters}
                        setActiveFilters={setActiveFilters}
                        className="mb-5"
                        btnClass="btn-sm"
                        listClass="d-flex flex-column"
                        allBtnClass="mx-2 py-2 mb-2"
                    />
                </Col>

                {/* The two views are controlled by a bootstrap tabs component,
                 ** using a custom layout. The Nav element contains the buttons that switch
                 ** the views, which are specified in each Tab.Pane element.
                */}
                <Col lg="9">
                    <Tab.Container defaultActiveKey="grid">
                        <Nav onSelect={() => setSelectedNote(null)}>
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
                                <GridView data={data} setSelected={setSelectedNote}></GridView>
                            </Tab.Pane>
                            <Tab.Pane eventKey="list">
                                <ListView
                                    data={data}
                                    setSelYear={setSelYear}
                                    setSelectedSubject={setSelectedSubject}
                                    setSelStudent={setSelStudent}
                                    setSelTeacher={setSelTeacher}
                                ></ListView>
                            </Tab.Pane>
                        </Tab.Content>
                    </Tab.Container>
                </Col>
            </Row>
        </div>
    );
}

export default Apontamentos;