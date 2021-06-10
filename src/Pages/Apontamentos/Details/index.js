import React from "react";
import './index.css';

const Details = ({ note, close }) => {
    return (
        note &&
        <div className="notesDetails bg-white p-3 mb-4">
            <h4 className="">Resumos FP 2018/2019 (zip)</h4>
            <button 
                type="button" 
                className="close" 
                data-dismiss="modal" 
                aria-label="Close"
                onClick={close}
            >
                <span aria-hidden="true">×</span>
            </button>
            <div className="row my-3">
                {note.summary === "1" && <span className="mb-1 badge badge-pill tag-summary"  >resumos</span>}
                {note.tests === "1" && <span className="mb-1 badge badge-pill tag-tests"    >testes</span>}
                {note.bibliography === "1" && <span className="mb-1 badge badge-pill tag-biblio"   >bibliografia</span>}
                {note.slides === "1" && <span className="mb-1 badge badge-pill tag-slides"   >slides</span>}
                {note.exercises === "1" && <span className="mb-1 badge badge-pill tag-exercises">exercícios</span>}
                {note.projects === "1" && <span className="mb-1 badge badge-pill tag-projects" >projetos</span>}
                {note.notebook === "1" && <span className="mb-1 badge badge-pill tag-notebook" >caderno</span>}
            </div>
            <div>
                <dl>
                    <dt className="small font-weight-bold">Ano letivo</dt>
                    <dd>{note.yearBegin}/{note.yearEnd}</dd>
                    <dt className="small font-weight-bold">Cadeira</dt>
                    <dd>{note.subjectName}</dd>
                    <dt className="small font-weight-bold">Autor</dt>
                    <dd className="text-lowercase text-capitalize">{note.authorName}</dd>
                    <dt className="small font-weight-bold">Docente</dt>
                    <dd>{note.teacherName}</dd>
                </dl>
            </div>
        </div>
    );
}

export default Details;