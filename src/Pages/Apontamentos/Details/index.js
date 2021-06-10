import React from "react";
import './index.css';

import parse from 'html-react-parser';

import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faInfoCircle, faFilter } from '@fortawesome/free-solid-svg-icons';

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

const Details = ({ note, close, setSelectedSubject, setSelYear, setSelStudent, setSelTeacher }) => {

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
                                    onClick={() => setSelYear(note.yearId)}
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
                                    onClick={() => setSelectedSubject(note.subjectId)}
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
                                    onClick={() => setSelStudent(note.authorId)}
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
                                        onClick={() => setSelTeacher(note.teacherId)}
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
                        note.content &&
                        <>
                            <dt className="small font-weight-bold">Ficheiros</dt>
                            <dd>{parse(note.content)}</dd>
                        </>
                    }
                </dl>
            </div>
        </div>
    );
}

export default Details;