import React, { useState, useEffect } from 'react';
import { Row, Col, Tab, Nav, Spinner } from 'react-bootstrap';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTh, faThList, faTimes, faShareAlt } from '@fortawesome/free-solid-svg-icons';
import ListView from './ListView';
import GridView from './GridView';
import "./index.css";
import PageNav from '../../Components/PageNav';
import Filters from "../../Components/Filters";
import Alert from '../../Components/Alert';
import Details from "./Details";
import Select from "react-select";
import Typist from 'react-typist';
import categoryFilters from './filters';

const Apontamentos = () => {

    // Grid view selected note
    const [selectedNote, setSelectedNote] = useState(null);


    // useStates and other variables
    const [data, setData] = useState([]);
    const [filters, setFilters] = useState([]);
    const [activeFilters, setActiveFilters] = useState([]);
    const [selection, setSelection] = useState([]);

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

    const [loading, setLoading] = useState(true);

    const [alert, setAlert] = useState({
        'type': null,
        'text': ""
    })


    const fetchPage = (p_num) => {
        console.log("currPage: " + selPage + ", new_page: " + p_num);

        setSelPage(p_num);
    }

    // When page loads
    useEffect(() => {
        // 1. Load category filters (static)
        setFilters(categoryFilters);
        setActiveFilters(categoryFilters.map(content => content.filter));
        // 2. Check if there are filtering parameters on URL
        // Get parameters and apply to filters
        const urlParams = new URLSearchParams(window.location.search);
        if(urlParams.get('year'))
            setSelYear(urlParams.get('year'));
        if(urlParams.get('subject'))
            setSelectedSubject(urlParams.get('subject'));
        if(urlParams.get('author'))
            setSelStudent(urlParams.get('author'));
        if(urlParams.get('teacher'))
            setSelTeacher(urlParams.get('teacher'));
        let active = [];
        urlParams.getAll('category').forEach((categoryParam) => {
            let find = categoryFilters.find(f => f.db==categoryParam);
            if (find) 
                active.push(find.filter);
        });
        if (active.length>0) {
            setActiveFilters(active);
        }
        // Remove data from URL
        var url = document.location.href;
        window.history.pushState({}, "", url.split("?")[0]);
    }, []);

    useEffect(() => {

        setLoading(true);

        // Every time a new call is made to the API, close details
        setSelectedNote(null);


        // extraVarName --> base used to concatenate and compare the optionals of every fetch
        var extraYear = selYear == "" ? "" : "schoolYear=" + selYear + "&";
        var extraSubj = selectedSubject == "" ? "" : "subject=" + selectedSubject + "&";
        var extraStud = selStudent == "" ? "" : "student=" + selStudent + "&";
        var extraTeacher = selTeacher == "" ? "" : "teacher=" + selTeacher + "&";
        var extraCategory = "";

        for (var i = 0; i < activeFilters.length; i++) {
            extraCategory += "category[]=" + filters.filter(f => f['filter'] == activeFilters[i])[0]['db'] + "&";
        }

        if (activeFilters.length == 0) {
            setData([]);
            setSelPage(1);
            setPageNumber(1);
            setLoading(false);
            return;
        }


        // fullVarName --> sum of optionals of every fetch
        var fullTeacher = "";

        if (extraYear != "" || extraSubj != "" || extraStud != "") {
            fullTeacher = "?";
            fullTeacher += extraYear;
            fullTeacher += extraSubj;
            fullTeacher += extraStud;
            fullTeacher = fullTeacher.substring(0, fullTeacher.length - 1); // ignore the last '&'
        }

        var fullYear = "";

        if (extraTeacher != "" || extraSubj != "" || extraStud != "") {
            fullYear = "?";
            fullYear += extraTeacher;
            fullYear += extraSubj;
            fullYear += extraStud;
            fullYear = fullYear.substring(0, fullYear.length - 1); // ignore the last '&'
        }

        var fullSubj = "";

        if (extraTeacher != "" || extraYear != "" || extraStud != "") {
            fullSubj = "?";
            fullSubj += extraYear;
            fullSubj += extraStud;
            fullSubj += extraTeacher;
            fullSubj = fullSubj.substring(0, fullSubj.length - 1); // ignore the last '&'
        }

        var fullStud = "";

        if (extraTeacher != "" || extraSubj != "" || extraYear != "") {
            fullStud = "?";
            fullStud += extraTeacher;
            fullStud += extraSubj;
            fullStud += extraYear;
            fullStud = fullStud.substring(0, fullStud.length - 1); // ignore the last '&'
        }

        if (extraCategory.length == 0) {
            setData([]);
        }
        else {
            var fullNotes = "?page=" + selPage + "&";

            fullNotes += extraTeacher;
            fullNotes += extraSubj;
            fullNotes += extraStud;
            fullNotes += extraCategory;
            fullNotes += extraYear;
            fullNotes = fullNotes.substring(0, fullNotes.length - 1); // ignore the last '&'

            fetch(process.env.REACT_APP_API + "/notes" + fullNotes)
                .then((response) => {
                    if (!response.ok) {throw new Error(response.status)}
                    return response.json()
                })
                .then((response) => {
                    if ('data' in response) {
                        setData(response.data)
                        setPageNumber(response.page.pagesNumber);
                    } else {
                        setData([]);
                        setPageNumber(1);
                    }
                    setLoading(false);
                })
                .catch((error) => {
                    console.log("Error getting notes!");
                    setAlert({
                        'type': 'alert',
                        'text': 'Ocorreu um erro ao processar o teu pedido. Por favor recarrega a página.'
                    });
                });
        }

        fetch(process.env.REACT_APP_API + "/notes/years" + fullYear)
            .then((response) => {
                if (!response.ok) {throw new Error(response.status)}
                return response.json()
            })
            .then((response) => {
                /*setYears(response.data.map( (year) => 
                    <option value={year.id} selected={year.id == selYear}>{year.yearBegin + "-" + year.yearEnd}</option>
                ))
                */
                if ('data' in response) {
                    var arr = response.data.map(year => {

                        const x = { value: year.id, label: year.yearBegin + "-" + year.yearEnd };
                        if (x.value == selYear)
                            setShownYear(x)
                        return x;
                    })

                    setYears(arr)
                }
            })
            .catch((error) => {
                console.log("Invalid parameters (no \"years\" matching)!");
                resetFilters();
                setAlert({
                    'type': 'alert',
                    'text': 'Ocorreu um erro ao processar os teus filtros. Os seus valores foram reinicializados, por favor tenta novamente.'
                });
            });

        fetch(process.env.REACT_APP_API + "/notes/subjects" + fullSubj)
            .then((response) => {
                if (!response.ok) {throw new Error(response.status)}
                return response.json()
            })
            .then((response) => {

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
            .catch((error) => {
                console.log("Invalid parameters (no \"subjects\" matching)!");
                resetFilters();
                setAlert({
                    'type': 'alert',
                    'text': 'Ocorreu um erro ao processar os teus filtros. Os seus valores foram reinicializados, por favor tenta novamente.'
                });
            });

        fetch(process.env.REACT_APP_API + "/notes/students" + fullStud)
            .then((response) => {
                if (!response.ok) {throw new Error(response.status)}
                return response.json()
            })
            .then((response) => {

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
            .catch((error) => {
                console.log("Invalid parameters (no \"students\" matching)!");
                resetFilters();
                setAlert({
                    'type': 'alert',
                    'text': 'Ocorreu um erro ao processar os teus filtros. Os seus valores foram reinicializados, por favor tenta novamente.'
                });
            });


        fetch(process.env.REACT_APP_API + "/notes/teachers" + fullTeacher)
            .then((response) => {
                if (!response.ok) {throw new Error(response.status)}
                return response.json()
            })
            .then((response) => {
                if ('data' in response) {
                    var arr = response.data.map(t => {
                        const x = { value: t.id, label: t.name };
                        if (x.value == selTeacher)
                            setShownTeacher(x)

                        return x;
                    })

                    setTeachers(arr)
                }
            })
            .catch((error) => {
                console.log("Invalid parameters (no \"teachers\" matching)!");
                resetFilters();
                setAlert({
                    'type': 'alert',
                    'text': 'Ocorreu um erro ao processar os teus filtros. Os seus valores foram reinicializados, por favor tenta novamente.'
                });
            });

    }, [activeFilters, selectedSubject, selStudent, selYear, selPage, selTeacher]);

    useEffect(() => {
        setSelPage(1);
    }, [activeFilters, selectedSubject, selStudent, selYear, selTeacher])

    // This method allows user to share the filtering parameters through a parameterized URL
    let linkShare = () => {
        // Build URL
        let url = window.location.origin + window.location.pathname + '?';
        if (selYear)
            url += `year=${selYear}&`;
        if (selectedSubject)
            url += `subject=${selectedSubject}&`;
        if (selStudent)
            url += `author=${selStudent}&`;
        if (selTeacher)
            url += `teacher=${selTeacher}&`;
        for (var i = 0; i < activeFilters.length; i++) {
            url += "category=" + filters.filter(f => f['filter'] == activeFilters[i])[0]['db'] + "&";
        }
        // Copy to user's clipboard
        navigator.clipboard.writeText(url.slice(0, -1)); // Remove last char (? if no filters or extra &)
        setAlert({
            'type': 'info',
            'text': "O URL foi copiado para a área de transferência! :)"
        });
    }

    let resetFilters = () => {
        setSelectedSubject("");
        setSelStudent("");
        setSelTeacher("");
        setSelYear("");
        setShownYear("");
        setShownSubj("");
        setShownAuth("");
        setShownTeacher("");
    }

    return (
        <div>
            <div class="d-flex flex-column mb-5">
                <h2 className="text-center mb-2">
                    <Typist>Apontamentos</Typist>
                </h2>
                <Alert 
                    alert={alert}
                    setAlert={setAlert}
                />
            </div>

            <Row className="mt-4">
                <Col className="d-flex flex-column" lg="4" xl="3">
                    <Details
                        className="order-2 order-lg-0"
                        note={selectedNote}
                        close={() => setSelectedNote(null)}
                        setSelYear={setSelYear}
                        setSelectedSubject={setSelectedSubject}
                        setSelStudent={setSelStudent}
                        setSelTeacher={setSelTeacher}
                        setSelPage={setSelPage}
                    />

                    <div className="filtros order-0 order-lg-1">

                        <h4>Filtros</h4>
                        {
                            (selectedSubject || selStudent || selTeacher || selYear) &&
                                <div className="d-flex flex-row flex-wrap mb-2">
                                    <button 
                                        className="rounded-pill btn btn-outline-primary btn-sm pill animation mr-2"
                                        onClick={() => linkShare()}    
                                        title="Copiar link com filtros"
                                    >
                                        <span className="mr-1">Partilhar</span>
                                        <FontAwesomeIcon
                                            className="my-auto link"
                                            icon={faShareAlt}
                                        />
                                    </button>
                                    <button 
                                        className="rounded-pill btn btn-outline-primary btn-sm pill animation mr-2"
                                        onClick={() => resetFilters()}    
                                        title="Remover filtros"
                                    >
                                        <span className="mr-1">Limpar</span>
                                        <FontAwesomeIcon 
                                            className="my-auto link" 
                                            icon={faTimes} 
                                        />
                                    </button>
                                </div>
                        }

                        <Select
                            id="teste"
                            className="react-select"
                            options={years}
                            onChange={(e) => { if (e == null) { setSelYear(""); setShownYear("") } else setSelYear(e.value); }}
                            placeholder="Ano Letivo..."
                            isClearable={true}
                            value={shownYear}

                        />

                        <Select
                            className="react-select"
                            options={subjects}
                            onChange={(e) => { if (e == null) { setSelectedSubject(""); setShownSubj("") } else setSelectedSubject(e.value) }}
                            placeholder="Cadeira..."
                            isClearable={true}
                            value={shownSubj}
                        />

                        <Select
                            className="react-select"
                            options={student}
                            onChange={(e) => { if (e == null) { setSelStudent(""); setShownAuth("") } else setSelStudent(e.value) }}
                            placeholder="Autor..."
                            isClearable={true}
                            value={shownAuth}
                        />

                        <Select
                            className="react-select"
                            options={teachers}
                            onChange={(e) => { if (e == null) { setSelTeacher(""); setShownTeacher("") } else setSelTeacher(e.value) }}
                            placeholder="Professor..."
                            isClearable={true}
                            value={shownTeacher}
                        />
                    </div>

                    <div className="order-1 order-lg-3">
                        <h4 className="mt-3">Categorias</h4>
                        <Filters
                            accordion={true}
                            filterList={filters}
                            activeFilters={activeFilters}
                            setActiveFilters={setActiveFilters}
                            className="mb-5"
                            btnClass="btn-sm"
                            listClass="d-flex flex-column"
                            allBtnClass="mb-2 p-0 col-12"
                        />
                    </div>
                </Col>

                {/* The two views are controlled by a bootstrap tabs component,
                 ** using a custom layout. The Nav element contains the buttons that switch
                 ** the views, which are specified in each Tab.Pane element.
                */}
                <Col lg="8" xl="9">

                    <Tab.Container defaultActiveKey="grid">
                        <Nav onSelect={() => setSelectedNote(null)}>
                            <Nav.Item className="mx-auto mx-lg-0 ml-lg-0"><Nav.Link eventKey="grid" className="h5">
                                <FontAwesomeIcon icon={faTh} />
                                <span className="ml-3">Grid</span>
                            </Nav.Link></Nav.Item>
                            <Nav.Item className="mx-auto mx-lg-0 mr-lg-auto"><Nav.Link eventKey="list" className="h5">
                                <FontAwesomeIcon icon={faThList} />
                                <span className="ml-3">List</span>
                            </Nav.Link></Nav.Item>
                            <PageNav
                                page={selPage}
                                total={pageNumber}
                                handler={fetchPage}
                                className="mx-auto mx-lg-0 ml-lg-auto"
                            ></PageNav>
                        </Nav>

                        <Tab.Content>
                            <Tab.Pane eventKey="grid">
                                <div className="d-flex">
                                    {
                                        loading ?
                                            <Spinner animation="grow" variant="primary" className="mx-auto mt-3" title="A carregar..." />
                                            :
                                            data.length == 0 ?
                                                <Col sm={12}>
                                                    <h3 className="text-center mt-3">Nenhum apontamento encontrado</h3>
                                                    <h4 className="text-center">Tente definir filtros menos restritivos</h4>
                                                </Col>
                                                :
                                                <GridView
                                                    data={data}
                                                    setSelected={setSelectedNote}
                                                ></GridView>
                                    }
                                </div>
                            </Tab.Pane>
                            <Tab.Pane eventKey="list" >
                                <div className="d-flex flex-column">
                                    {
                                        loading ?
                                            <Spinner animation="grow" variant="primary" className="mx-auto mt-3" title="A carregar..." />
                                            :
                                            data.length == 0 ?
                                                <Col sm={12}>
                                                    <h3 className="text-center mt-3">Nenhum apontamento encontrado</h3>
                                                    <h4 className="text-center">Tente definir filtros menos restritivos</h4>
                                                </Col>
                                                :
                                                <ListView
                                                    data={data}
                                                    setSelYear={setSelYear}
                                                    setSelectedSubject={setSelectedSubject}
                                                    setSelStudent={setSelStudent}
                                                    setSelTeacher={setSelTeacher}
                                                ></ListView>
                                    }
                                </div>
                            </Tab.Pane>
                        </Tab.Content>
                    </Tab.Container>
                </Col>
            </Row>

            <div className="text-center mt-5">
                <h3>É a tua vez!</h3>
                <p>
                    Ajuda-nos a manter este repositório atualizado com os conteúdos mais recentes. Partilha connosco os teus através do email <a href="mailto:nei@aauav.pt">nei@aauav.pt</a>. Contamos com o teu apoio!
                </p>
            </div>
        </div>
    );
}

export default Apontamentos;