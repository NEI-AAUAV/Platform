import React from 'react';
import { Row, Col, Accordion } from 'react-bootstrap';
import "./index.css";

/** Takes a single prop: data, an object containing the following properties:
 *  - id
    - name: the name of the file
    - subjectShort: abbreviation of subject name (e.g. "FP")
    - subjectName: full subject name
    - summary, tests, bibliography, slides, exercises, projects, notebook:
        The string "0" or "1", representing if the notes belong in the category 
 */
const ListViewItem = (props) => {
    
    return(
        <div className="my-3" eventKey={props.data.id}>
            <Row>
                <Col md="5" className="list-view-name">
                    {props.data.name}
                </Col>
                <Col md="5" className="list-view-subject-name">
                    {props.data.subjectName}
                </Col>
                <Col md="2" className="list-view-subject-short">
                    {props.data.subjectShort}
                </Col>
            </Row>
            <Row className="pl-2">
                {props.data.summary     ==="1" && <span className="badge badge-pill tag-summary"  >resumos</span>}
                {props.data.tests       ==="1" && <span className="badge badge-pill tag-tests"    >testes</span>}
                {props.data.bibliography==="1" && <span className="badge badge-pill tag-biblio"   >bilbiografia</span>}
                {props.data.slides      ==="1" && <span className="badge badge-pill tag-slides"   >slides</span>}
                {props.data.exercises   ==="1" && <span className="badge badge-pill tag-exercises">exercícios</span>}
                {props.data.projects    ==="1" && <span className="badge badge-pill tag-projects" >projetos</span>}
                {props.data.notebook    ==="1" && <span className="badge badge-pill tag-notebook" >caderno</span>}
            </Row>
        </div>
    );
}

export default ListViewItem;