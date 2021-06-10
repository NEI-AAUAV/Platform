import React from 'react';
import { Row, Col, Accordion } from 'react-bootstrap';
import "./index.css";

/** Takes a single prop: data, a list of objects containing the following properties:
 *  - id
    - name: the name of the file
    - subjectShort: abbreviation of subject name (e.g. "FP")
    - subjectName: full subject name
    - summary, tests, bibliography, slides, exercises, projects, notebook:
        The string "0" or "1", representing if the notes belong in the category 
 */
const ListView = (props) => {
    
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

            {
            props.data.map( item => {
                return(
                    <div className="list-view-item mx-n3 px-3">
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
                            {item.summary     ==="1" && <span className="badge badge-pill tag-summary"  >resumos</span>}
                            {item.tests       ==="1" && <span className="badge badge-pill tag-tests"    >testes</span>}
                            {item.bibliography==="1" && <span className="badge badge-pill tag-biblio"   >bibliografia</span>}
                            {item.slides      ==="1" && <span className="badge badge-pill tag-slides"   >slides</span>}
                            {item.exercises   ==="1" && <span className="badge badge-pill tag-exercises">exercícios</span>}
                            {item.projects    ==="1" && <span className="badge badge-pill tag-projects" >projetos</span>}
                            {item.notebook    ==="1" && <span className="badge badge-pill tag-notebook" >caderno</span>}
                        </Row>
                    </div>
            )})
            }
            
        </div>
    );
}

export default ListView;