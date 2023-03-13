import React from 'react';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faInfoCircle, faFilter, faCloudDownloadAlt } from '@fortawesome/free-solid-svg-icons';
import "./index.css";

import { authorNameProcessing, monthsPassed } from '../utils';

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

    return (
        <div className="mx-3">
            <div className="list-view-header">
                <div md="4" className="list-view-name">
                    Ficheiro
                </div>
                <div md="4" className="list-view-subject-name">
                    Cadeira
                </div>
                <div md="1" className="list-view-subject-short">
                    Sigla
                </div>
                <div md="3" className="list-view-subject-name">
                    Autor
                </div>
            </div>

            <div>
                {
                    props.data.map((item, index) => {
                        return (
                            <React.Fragment key={index}>
                                <div
                                    className="list-view-item mx-n3 px-3 slideUpFade"
                                    style={{ animationDelay: animKey++ * 0.1 + "s" }}
                                >
                                    <div>
                                        <div>
                                            <div md="4" className="list-view-name">
                                                {item.name}
                                            </div>
                                            <div md="4" className="list-view-subject-name">
                                                {item.subject?.name}
                                            </div>
                                            <div md="1" className="list-view-subject-short">
                                                {item.subject?.short}
                                            </div>
                                            <div md="3" className="list-view-subject-name">
                                                {authorNameProcessing(item.author?.name)}
                                            </div>
                                        </div>
                                        <div className="pl-2 mt-1">
                                            {monthsPassed(new Date(item.created_at)) < 3 && <span className="badge mr-0 ml-1 badge-pill tag-new"  >Novo!</span>}
                                            {item.summary === "1" && <span className="badge mr-0 ml-1 badge-pill tag-summary"  >Resumos</span>}
                                            {item.tests === "1" && <span className="badge mr-0 ml-1 badge-pill tag-tests"    >Testes e exames</span>}
                                            {item.bibliography === "1" && <span className="badge mr-0 ml-1 badge-pill tag-biblio"   >Bibliografia</span>}
                                            {item.slides === "1" && <span className="badge mr-0 ml-1 badge-pill tag-slides"   >Slides</span>}
                                            {item.exercises === "1" && <span className="badge mr-0 ml-1 badge-pill tag-exercises">Exercícios</span>}
                                            {item.projects === "1" && <span className="badge mr-0 ml-1 badge-pill tag-projects" >Projetos</span>}
                                            {item.notebook === "1" && <span className="badge mr-0 ml-1 badge-pill tag-notebook" >Caderno</span>}
                                        </div>
                                    </div>
                                    <div>
                                        <div>
                                            <div>
                                                <div sm="12" lg="8">
                                                    <dl className="mb-2">
                                                        {
                                                            !!item.school_year?.year_begin && !!item.school_year?.year_end &&
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
                                                                <dd>{item.school_year?.year_begin}/{item.school_year?.year_end}</dd>
                                                            </>
                                                        }
                                                        {
                                                            !!item.author?.name &&
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
                                                                <dd>{titleCase(item.author?.name)}</dd>
                                                            </>
                                                        }
                                                        {
                                                            !!item.teacher?.name &&
                                                            <>
                                                                <dt className="small font-weight-bold">
                                                                    <span className="mr-1">
                                                                        <span className="mr-1">Docente</span>
                                                                        <FontAwesomeIcon
                                                                            className="text-primary mr-1 link"
                                                                            icon={faFilter}
                                                                            size={"1x"}
                                                                            title="Filtrar por docente"
                                                                            onClick={() => props.setSelTeacher(item.teacher?.id)}
                                                                        />
                                                                    </span>
                                                                    {
                                                                        !!item.teacher?.page &&
                                                                        <a
                                                                            title="Perfil do docente ua.pt"
                                                                            href={item.teacher?.page}
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
                                                                <dd>{item.teacher?.name}</dd>
                                                            </>
                                                        }
                                                    </dl>
                                                </div>
                                                <div sm="12" lg="4">
                                                    <a
                                                        href={item.location}
                                                        target="_blank" rel="noreferrer"
                                                    >
                                                        <button className="btn btn-sm btn-outline-primary mb-3 ml-0">
                                                            <FontAwesomeIcon icon={item.type?.icon_download.split(" ")} size={"1x"} />
                                                            <span className="ml-1">{item.type?.download_caption}</span>
                                                        </button>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </React.Fragment>
                        )
                    })
                }
            </div>
        </div>
    );
}

export default ListView;