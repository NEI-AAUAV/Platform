import React, {useState, useEffect} from "react";
import { Spinner, Nav, Tab } from "react-bootstrap";
import './index.css';

import parse from 'html-react-parser';

import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faInfoCircle, faFilter, faCloudDownloadAlt } from '@fortawesome/free-solid-svg-icons';

function titleCase(str) {
    var splitStr = str.toLowerCase().split(' ');
    for (var i = 0; i < splitStr.length; i++) {
        // You do not need to check if i is larger than splitStr length, as your for does that for you
        // Assign it back to the array
        splitStr[i] = splitStr[i].charAt(0).toUpperCase() + splitStr[i].substring(1);
    }
    // Directly return the joined string
    return splitStr.join(' ');
}

const Details = ({ note_id, close, setSelectedSubject, setSelYear, setSelStudent, setSelTeacher, setSelPage, className, setAlert }) => {

    const [loading, setLoading] = useState(true);
    const [note, setNote] = useState(null);
    const [tags, setTags] = useState([]);

    useEffect(() => {
        setLoading(true);

        // Get note data from API when component loads
        fetch(process.env.REACT_APP_API + "/notes/?note=" + note_id)
                .then((response) => {
                    if (!response.ok) {throw new Error(response.status)}
                    return response.json();
                })
                .then((response) => {
                    if ('data' in response && response['data']) {
                        setNote(response.data);
                    } else {
                        throw new Error('Note not found!');
                    }
                })
                .catch((error) => {
                    console.error("Error getting note:", note_id, error);
                    setAlert({
                        'type': 'alert',
                        'text': 'Ocorreu um erro ao obter os dados do apontamento que selecionaste. Por favor tenta novamente.'
                    });
                })
                .finally(() => {
                    setLoading(false);
                });
    }, [note_id]);

    useEffect(() => {
        var note_tags = [];
        if (note) {
            note.summary == "1" && note_tags.push({ "name": "Resumos", "className": "tag-summary" });
            note.tests == "1" && note_tags.push({ "name": "Testes e exames", "className": "tag-tests" });
            note.bibliography == "1" && note_tags.push({ "name": "Bibliografia", "className": "tag-biblio" });
            note.slides == "1" && note_tags.push({ "name": "Slides", "className": "tag-slides" });
            note.exercises == "1" && note_tags.push({ "name": "Exercícios", "className": "tag-exercises" });
            note.projects == "1" && note_tags.push({ "name": "Projetos", "className": "tag-projects" });
            note.notebook == "1" && note_tags.push({ "name": "Caderno", "className": "tag-notebook" });
        }
        setTags(note_tags);

        // Scroll to element
        if(document.getElementById("apontamentosPage")!=null) {
            document.getElementById("apontamentosPage").scrollIntoView({behavior: 'smooth'});
        }
    }, [note]);

    return (
        <div className={"notesDetails p-3 mb-4 animation d-flex flex-column " + className}>
            {
                loading
                ? <Spinner animation="grow" variant="primary" className="mx-auto mt-3" title="A carregar..." />
                : 
                <>
                    <div className="d-flex flex-row">
                        <h4 className="break-all mr-auto">{note.name}</h4>
                        <button
                            type="button"
                            className="close mb-auto ml-auto"
                            data-dismiss="modal"
                            aria-label="Close"
                            onClick={close}
                        >
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <div className="row mx-0 my-3">
                        {
                            tags.map(
                                tag =>
                                    <span
                                        className={"ml-0 mb-1 mr-1 badge badge-pill " + tag.className}
                                    >{tag.name}</span>
                            )
                        }
                    </div>
                    <a 
                        href={parseInt(note.type_external) ? note.location : process.env.REACT_APP_STATIC + note.location} 
                        target="_blank" rel="noreferrer"
                        >
                        <button className="btn btn-sm btn-outline-primary mb-3 ml-0">
                            <FontAwesomeIcon
                                icon={note.type_icon_download.split(" ")}
                                size={"1x"}
                            />
                            <span className="ml-1">{note.type_download_caption}</span>
                        </button>
                    </a>

                    {
                        false &&
                        <Tab.Container defaultActiveKey="first" id="uncontrolled-tab-example" className="mb-3">
                            {
                                note.content &&
                                <Nav variant="pills" className="flex-row">
                                    <Nav.Item>
                                        <Nav.Link eventKey="first">Detalhes</Nav.Link>
                                    </Nav.Item>
                                    <Nav.Item>
                                        <Nav.Link eventKey="second">Conteúdo</Nav.Link>
                                    </Nav.Item>
                                </Nav>
                            }
                            <Tab.Content>
                                <Tab.Pane eventKey="first">
                                    <h1>Tab1</h1>
                                </Tab.Pane>
                                <Tab.Pane eventKey="second">
                                    <h1>Tab2</h1>
                                </Tab.Pane>
                            </Tab.Content>
                        </Tab.Container>
                    }

                    <div>
                        <dl>
                            {
                                note.yearBegin && note.yearEnd &&
                                <>
                                    <dt className="small font-weight-bold">
                                        <span className="mr-1">Ano letivo</span>
                                        <FontAwesomeIcon
                                            className="text-primary mr-1 link"
                                            icon={faFilter}
                                            size={"1x"}
                                            title="Filtrar por ano letivo"
                                            onClick={() => { setSelYear(note.yearId); setSelPage(1) }}
                                        />
                                    </dt>
                                    <dd>{note.yearBegin}/{note.yearEnd}</dd>
                                </>
                            }
                            {
                                note.subjectName &&
                                <>
                                    <dt className="small font-weight-bold">
                                        <span className="mr-1">Cadeira</span>
                                        <FontAwesomeIcon
                                            className="text-primary mr-1 link"
                                            icon={faFilter}
                                            size={"1x"}
                                            title="Filtrar por cadeira"
                                            onClick={() => { setSelectedSubject(note.subjectId); setSelPage(1) }}
                                        />
                                    </dt>
                                    <dd>{note.subjectName}</dd>
                                </>
                            }
                            {
                                note.authorName &&
                                <>
                                    <dt className="small font-weight-bold">
                                        <span className="mr-1">Autor</span>
                                        <FontAwesomeIcon
                                            className="text-primary mr-1 link"
                                            icon={faFilter}
                                            size={"1x"}
                                            title="Filtrar por autor"
                                            onClick={() => { setSelStudent(note.authorId); setSelPage(1) }}
                                        />
                                    </dt>
                                    <dd>{titleCase(note.authorName)}</dd>
                                </>
                            }
                            {
                                note.teacherName &&
                                <>
                                    <dt className="small font-weight-bold">
                                        <span className="mr-1">
                                            <span className="mr-1">Docente</span>
                                            <FontAwesomeIcon
                                                className="text-primary mr-1 link"
                                                icon={faFilter}
                                                size={"1x"}
                                                title="Filtrar por docente"
                                                onClick={() => { setSelTeacher(note.teacherId); setSelPage(1) }}
                                            />
                                        </span>
                                        {
                                            note.teacherPage &&
                                            <a
                                                title="Perfil do docente ua.pt"
                                                href={note.teacherPage}
                                                target="_blank"
                                                rel="noreferrer"
                                            >

                                                <FontAwesomeIcon
                                                    className="text-primary mr-3"
                                                    icon={faInfoCircle}
                                                    size={"1x"}
                                                />
                                            </a>
                                        }
                                    </dt>
                                    <dd>{note.teacherName}</dd>
                                </>
                            }
                            {
                                (note.content || note.size) &&
                                <div class="file-content">
                                    <dt className="small font-weight-bold">
                                        Conteúdo
                                        {note.size && <small className="ml-1">({note.size} MB)</small>}
                                    </dt>
                                    {
                                        note.content &&
                                        <dd>{parse(`${note.content.replace('\n', '<br/>')}`)}</dd>
                                    }
                                </div>
                            }
                        </dl>
                    </div>
                </>
            }
        </div>
    );
}

export default Details;