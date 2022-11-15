import React, { useState, useEffect } from 'react';
import { Row, Col, Tab, Nav, Spinner } from 'react-bootstrap';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTh, faThList, faTimes, faShareAlt } from '@fortawesome/free-solid-svg-icons';
import ListView from './ListView';
import GridView from './GridView';
import "./index.css";
import PageNav from '../../components/PageNav';
import Filters from "../../components/Filters";
import Alert from '../../components/Alert';
import Details from "./Details";
import Select from "components/Select";
import Typist from 'react-typist';
import categoryFilters from './filters';

import service from 'services/NEIService';


const customStyles = {
    menu: (provided) => ({
        ...provided,
        backgroundColor: "var(--background)",
        color: "var(--text-primary)"
    }),

    control: (provided) => ({
        //   width: width
        ...provided,
        backgroundColor: "var(--background)",
        color: "var(--text-primary)"
    }),

    placeholder: (provided, state) => ({
        ...provided,
        opacity: 1,
        color: "var(--text-primary)",
    }),

    option: (provided, state) => ({
        ...provided,
        // borderBottom: '1px dotted pink',
        //color: state.isSelected ? 'red' : 'blue',
        // padding: 20,
        backgroundColor: "var(--background)",
        color: "var(--text-primary)"
    }),

    singleValue: (provided, state) => {
        const opacity = state.isDisabled ? 0.5 : 1;
        const transition = 'opacity 300ms';
        const color = "var(--text-primary)";
        return { ...provided, opacity, transition, color };
    },

}

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

    const [thanks, setThanks] = useState([]);

    const [loading, setLoading] = useState(true);

    const [alert, setAlert] = useState({
        'type': null,
        'text': ""
    })

    const fetchPage = (p_num) => {
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
        if (urlParams.get('year'))
            setSelYear(urlParams.get('year'));
        if (urlParams.get('subject'))
            setSelectedSubject(urlParams.get('subject'));
        if (urlParams.get('author'))
            setSelStudent(urlParams.get('author'));
        if (urlParams.get('teacher'))
            setSelTeacher(urlParams.get('teacher'));
        let active = [];
        urlParams.getAll('category').forEach((categoryParam) => {
            let find = categoryFilters.find(f => f.db == categoryParam);
            if (find)
                active.push(find.filter);
        });
        if (active.length > 0) {
            setActiveFilters(active);
        }
        // Remove data from URL
        var url = document.location.href;
        window.history.pushState({}, "", url.split("?")[0]);
        // Load thanks
        service.getNotesThanks()
            .then((data) => {
                setThanks(data);
            })
    }, []);

    useEffect(() => {

        setLoading(true);

        // Every time a new call is made to the API, close details
        setSelectedNote(null);

        const params = {
            school_year: selYear || null,
            subject: selectedSubject || null,
            student: selStudent || null,
            teacher: selTeacher || null,
            category: []
        }

        for (var i = 0; i < activeFilters.length; i++) {
            const cat = filters.filter(f => f['filter'] == activeFilters[i])[0]['db'];
            params.category.push(cat);
        }

        if (activeFilters.length == 0) {
            setData([]);
            setSelPage(1);
            setPageNumber(1);
            setLoading(false);
            return;
        }

        if (params.category.length == 0) {
            setData([]);
        }
        else {
            service.getNotes({ ...params, page: selPage })
                .then(({ items, total }) => {
                    setData(items);
                    setPageNumber(total || 1);
                    setLoading(false);
                })
                .catch(() => {
                    setAlert({
                        'type': 'alert',
                        'text': 'Ocorreu um erro ao processar o teu pedido. Por favor recarrega a página.'
                    });
                });
        }

        service.getNotesYears(params)
            .then((data) => {
                const arr = data.map(year => {
                    const x = { value: year.id, label: year.yearBegin + "-" + year.yearEnd };
                    if (x.value == selYear)
                        setShownYear(x);
                    return x;
                })
                setYears(arr);
            })
            .catch(() => {
                console.error("Invalid parameters (no \"years\" matching)!");
                resetFilters();
                setAlert({
                    'type': 'alert',
                    'text': 'Ocorreu um erro ao processar os teus filtros. Os seus valores foram reinicializados, por favor tenta novamente.'
                });
            });

        service.getNotesSubjects(params)
            .then((data) => {
                const arr = data.map(subj => {
                    const x = { value: subj.paco_code, label: subj.short };
                    if (x.value == selectedSubject)
                        setShownSubj(x);
                    return x;
                })
                setSubjects(arr);
            })
            .catch(() => {
                console.error("Invalid parameters (no \"subjects\" matching)!");
                resetFilters();
                setAlert({
                    'type': 'alert',
                    'text': 'Ocorreu um erro ao processar os teus filtros. Os seus valores foram reinicializados, por favor tenta novamente.'
                });
            });

        service.getNotesStudents(params)
            .then((data) => {
                const arr = data.map(t => {
                    const x = { value: t.id, label: t.name };
                    if (x.value == selStudent)
                        setShownAuth(x)
                    return x;
                })
                setStudents(arr);
            })
            .catch(() => {
                console.error("Invalid parameters (no \"students\" matching)!");
                resetFilters();
                setAlert({
                    'type': 'alert',
                    'text': 'Ocorreu um erro ao processar os teus filtros. Os seus valores foram reinicializados, por favor tenta novamente.'
                });
            });

        service.getNotesTeachers(params)
            .then((data) => {
                const arr = data.map(t => {
                    const x = { value: t.id, label: t.name };
                    if (x.value == selTeacher)
                        setShownTeacher(x)
                    return x;
                })
                setTeachers(arr);
            })
            .catch(() => {
                console.error("Invalid parameters (no \"teachers\" matching)!");
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
        if (selYear != "")
            url += `year=${selYear}&`;
        if (selectedSubject != "")
            url += `subject=${selectedSubject}&`;
        if (selStudent != "")
            url += `author=${selStudent}&`;
        if (selTeacher != "")
            url += `teacher=${selTeacher}&`;
        // Only include filters tags if not all selected (because if missing from url, all will be selected by default)
        if (activeFilters.length !== filters.length) {
            for (var i = 0; i < activeFilters.length; i++) {
                url += "category=" + filters.filter(f => f['filter'] == activeFilters[i])[0]['db'] + "&";
            }
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
        <div id="apontamentosPage">
            <div className="d-flex flex-column mb-5">
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
                    {
                        selectedNote && selectedNote.id &&
                        <Details
                            className="order-2 order-lg-0"
                            note_id={selectedNote.id}
                            close={() => setSelectedNote(null)}
                            setSelYear={setSelYear}
                            setSelectedSubject={setSelectedSubject}
                            setSelStudent={setSelStudent}
                            setSelTeacher={setSelTeacher}
                            setSelPage={setSelPage}
                            setAlert={setAlert}
                        />
                    }

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
                            styles={customStyles}
                            className="react-select"
                            options={years}
                            onChange={(e) => { if (e == null) { setSelYear(""); setShownYear("") } else setSelYear(e.value); }}
                            placeholder="Ano Letivo..."
                            isClearable={true}
                            value={shownYear}

                        />

                        <Select
                            className="react-select"
                            styles={customStyles}
                            options={subjects}
                            onChange={(e) => { if (e == null) { setSelectedSubject(""); setShownSubj("") } else setSelectedSubject(e.value) }}
                            placeholder="Cadeira..."
                            isClearable={true}
                            value={shownSubj}
                        />

                        <Select
                            className="react-select"
                            styles={customStyles}
                            options={student}
                            onChange={(e) => { if (e == null) { setSelStudent(""); setShownAuth("") } else setSelStudent(e.value) }}
                            placeholder="Autor..."
                            isClearable={true}
                            value={shownAuth}
                        />

                        <Select
                            className="react-select"
                            styles={customStyles}
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

                    <Tab.Container defaultActiveKey={window.innerWidth >= 992 ? "grid" : "list"}>
                        <div>
                            <Nav onSelect={() => setSelectedNote(null)}>
                                <Nav.Item className="mx-auto mx-lg-0 ml-lg-0 d-none d-lg-block"><Nav.Link eventKey="grid" className="h5">
                                    <FontAwesomeIcon icon={faTh} />
                                    <span className="ml-3">Grid</span>
                                </Nav.Link></Nav.Item>
                                <Nav.Item className="mx-auto mx-lg-0 mr-lg-auto d-none d-lg-block"><Nav.Link eventKey="list" className="h5">
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
                        </div>

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
                    <PageNav
                        page={selPage}
                        total={pageNumber}
                        handler={fetchPage}
                        className="mx-auto d-lg-none mt-3"
                    ></PageNav>
                </Col>
            </Row>
            {
                !!thanks.length &&
                <div className="text-center mt-5">
                    <h3>Foi graças a pessoas como tu que esta página se tornou possível!</h3>

                    <div>
                        <p className="m-0">O nosso agradecimento aos que mais contribuiram.</p>

                        <Row>
                            {
                                thanks.map(t =>
                                    <div className="mx-auto my-3">
                                        <h4 className="">{t.author}</h4>
                                        <div className="small">
                                            <a href={'/apontamentos?author=' + t.authorId}>Os seus apontamentos no site do NEI</a>
                                            <br />
                                            {
                                                t.personalPage && <a href={t.personalPage} target="_blank">Website de apontamentos</a>
                                            }
                                        </div>
                                    </div>
                                )
                            }
                        </Row>
                    </div>
                    <p>
                        Junta-te a elas e ajuda-nos a manter este repositório atualizado com os conteúdos mais recentes. Partilha connosco os teus através do email <a href="mailto:nei@aauav.pt">nei@aauav.pt</a>. Contamos com o teu apoio!
                    </p>
                </div>
            }
        </div>
    );
}

export default Apontamentos;