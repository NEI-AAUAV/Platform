import React from 'react';
import { Row, Col, Accordion, Card } from 'react-bootstrap';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faInfoCircle, faFilter, faCloudDownloadAlt } from '@fortawesome/free-solid-svg-icons';
import "./index.css";

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

/** Takes a single prop: data, a list of objects containing the following properties:
 *  - id
    - name: the name of the file
    - subjectShort: abbreviation of subject name (e.g. "FP")
    - subjectName: full subject name
    - summary, tests, bibliography, slides, exercises, projects, notebook:
        The string "0" or "1", representing if the notes belong in the category 
 */
const ListView = (props) => {
    
    var animKey = 0;

    return(
        <div className="mx-3">
            <Row className="list-view-header">
                <Col md="5" className="list-view-name">
                    Ficheiro
                </Col>
                <Col md="5" className="list-view-subject-name">
                    Cadeira
                </Col>
                <Col md="2" className="list-view-subject-short">
                    Sigla
                </Col>
            </Row>

            <Accordion>
            {
            props.data.map( item => {
                return(
                    <Card
                        className="list-view-item mx-n3 px-3 slideUpFade"
                        style={{animationDelay: animKey++*0.1+"s"}}
                    >
                        <Accordion.Toggle as={Card.Header} eventKey={item.id}>
                            <Row>
                                <Col md="5" className="list-view-name">
                                    {item.name}
                                </Col>
                                <Col md="5" className="list-view-subject-name">
                                    {item.subjectName}
                                </Col>
                                <Col md="2" className="list-view-subject-short">
                                    {item.subjectShort}
                                </Col>
                            </Row>
                            <Row className="pl-2 mt-1">
                                {item.summary     ==="1" && <span className="badge mr-0 ml-1 badge-pill tag-summary"  >Resumos</span>}
                                {item.tests       ==="1" && <span className="badge mr-0 ml-1 badge-pill tag-tests"    >Testes e exames</span>}
                                {item.bibliography==="1" && <span className="badge mr-0 ml-1 badge-pill tag-biblio"   >Bibliografia</span>}
                                {item.slides      ==="1" && <span className="badge mr-0 ml-1 badge-pill tag-slides"   >Slides</span>}
                                {item.exercises   ==="1" && <span className="badge mr-0 ml-1 badge-pill tag-exercises">Exercícios</span>}
                                {item.projects    ==="1" && <span className="badge mr-0 ml-1 badge-pill tag-projects" >Projetos</span>}
                                {item.notebook    ==="1" && <span className="badge mr-0 ml-1 badge-pill tag-notebook" >Caderno</span>}
                            </Row>
                        </Accordion.Toggle>

                        <Accordion.Collapse eventKey={item.id}>
                            <Card.Body>
                                <Row>
                                    <Col sm="12" lg="8">
                                        <dl className="mb-2">
                                            {
                                            item.yearBegin && item.yearEnd &&
                                            <>
                                                <dt className="small font-weight-bold">
                                                    <span className="mr-1">Ano letivo</span>
                                                    <FontAwesomeIcon
                                                        className="text-primary mr-1 link"
                                                        icon={faFilter}
                                                        size={"1x"}
                                                        title="Filtrar por ano letivo"
                                                        onClick={() => props.setSelYear(item.yearId)}
                                                    />
                                                </dt>
                                                <dd>{item.yearBegin}/{item.yearEnd}</dd>
                                            </>
                                            }
                                            {
                                            item.authorName &&
                                            <>
                                                <dt className="small font-weight-bold">
                                                    <span className="mr-1">Autor</span>
                                                    <FontAwesomeIcon
                                                        className="text-primary mr-1 link"
                                                        icon={faFilter}
                                                        size={"1x"}
                                                        title="Filtrar por autor"
                                                        onClick={() => props.setSelStudent(item.authorId)}
                                                    />
                                                </dt>
                                                <dd>{titleCase(item.authorName)}</dd>
                                            </>
                                            }
                                            {
                                            item.teacherName &&
                                            <>
                                                <dt className="small font-weight-bold">
                                                    <span className="mr-1">
                                                        <span className="mr-1">Docente</span>
                                                        <FontAwesomeIcon
                                                            className="text-primary mr-1 link"
                                                            icon={faFilter}
                                                            size={"1x"}
                                                            title="Filtrar por docente"
                                                            onClick={() => props.setSelTeacher(item.teacherId)}
                                                        />
                                                    </span>
                                                    {
                                                    item.teacherPage &&
                                                    <a
                                                        title="Perfil do docente ua.pt"
                                                        href={item.teacherPage}
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
                                                <dd>{item.teacherName}</dd>
                                            </>
                                        }
                                        </dl>
                                    </Col>
                                    <Col sm="12" lg="4">
                                        <a href={process.env.REACT_APP_UPLOADS_UNLOCK + item.location} target="_blank" rel="noreferrer">
                                            <button className="btn btn-sm btn-outline-primary mb-3 ml-0">
                                                <FontAwesomeIcon icon={faCloudDownloadAlt} size={"1x"}/>
                                                <span className="ml-1">Descarregar</span>
                                            </button>
                                        </a>
                                    </Col>
                                </Row>
                            </Card.Body>
                        </Accordion.Collapse>
                    </Card>
            )})
            }
            </Accordion>
        </div>
    );
}

export default ListView;