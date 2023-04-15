import React, { useState, useEffect } from "react";
import { Spinner, Nav, Tab } from "react-bootstrap";
import "./index.css";

import parse from "html-react-parser";

import { FilePDFIcon, FolderZipIcon, DownloadIcon, OpenInNewIcon } from "assets/icons/google";
import { GithubIcon, GoogleDriveIcon } from "assets/icons/social";

import service from "services/NEIService";

function titleCase(str) {
  var splitStr = str.toLowerCase().split(" ");
  for (var i = 0; i < splitStr.length; i++) {
    // You do not need to check if i is larger than splitStr length, as your for does that for you
    // Assign it back to the array
    splitStr[i] =
      splitStr[i].charAt(0).toUpperCase() + splitStr[i].substring(1);
  }
  // Directly return the joined string
  return splitStr.join(" ");
}

const Details = ({
  note_id,
  close,
  setSelectedSubject,
  setSelYear,
  setSelStudent,
  setSelTeacher,
  setSelPage,
  className,
  setAlert,
}) => {
  const [loading, setLoading] = useState(true);
  const [note, setNote] = useState(null);
  const [tags, setTags] = useState([]);

  useEffect(() => {
    setLoading(true);

    // Get note data from API when component loads
    service
      .getNotesById(note_id)
      .then((data) => setNote(data))
      .catch(() => {
        console.error("Error getting note:", note_id);
        setAlert({
          type: "alert",
          text: "Ocorreu um erro ao obter os dados do apontamento que selecionaste. Por favor tenta novamente.",
        });
      })
      .finally(() => {
        setLoading(false);
      });
  }, [note_id]);

  useEffect(() => {
    var note_tags = [];
    if (note) {
      note.summary == "1" &&
        note_tags.push({ name: "Resumos", className: "tag-summary" });
      note.tests == "1" &&
        note_tags.push({ name: "Testes e exames", className: "tag-tests" });
      note.bibliography == "1" &&
        note_tags.push({ name: "Bibliografia", className: "tag-biblio" });
      note.slides == "1" &&
        note_tags.push({ name: "Slides", className: "tag-slides" });
      note.exercises == "1" &&
        note_tags.push({ name: "Exercícios", className: "tag-exercises" });
      note.projects == "1" &&
        note_tags.push({ name: "Projetos", className: "tag-projects" });
      note.notebook == "1" &&
        note_tags.push({ name: "Caderno", className: "tag-notebook" });

      // TODO: refactor this so that it does not repeat the same code in Notes/index.js
      if (note.location.endsWith(".pdf")) {
        note.type = {
          caption: "Descarregar",
          Icon: FilePDFIcon,
          download: true,
        };
      } else if (note.location.endsWith(".zip")) {
        note.type = {
          caption: "Descarregar",
          Icon: FolderZipIcon,
          download: true,
        };
      } else if (note.location.startsWith("https://github.com/")) {
        note.type = {
          caption: "Repositório",
          Icon: GithubIcon,
          download: false,
        };
      } else if (note.location.startsWith("https://drive.google.com/")) {
        note.type = {
          caption: "Google Drive",
          Icon: GoogleDriveIcon,
          download: false,
        };
      }
    }
    setTags(note_tags);

    // Scroll to element
    if (document.getElementById("apontamentosPage") != null) {
      document
        .getElementById("apontamentosPage")
        .scrollIntoView({ behavior: "smooth" });
    }
  }, [note]);

  return (
    <div
      className={
        "notesDetails animation d-flex flex-column mb-4 p-3 " + className
      }
    >
      {!!loading ? (
        <Spinner
          animation="grow"
          variant="primary"
          className="mx-auto mt-3"
          title="A carregar..."
        />
      ) : (
        <>
          <div className="d-flex flex-row">
            <h4 className="mr-auto break-all">{note.name}</h4>
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
            {tags.map((tag, index) => (
              <span
                key={index}
                className={"badge-pill badge ml-0 mb-1 mr-1 " + tag.className}
              >
                {tag.name}
              </span>
            ))}
          </div>
          <a href={note.location} target="_blank" rel="noreferrer">
            <button className="btn-sm btn mb-3 ml-0">
              {!note.type?.download ? (
                <>
                  <OpenInNewIcon />
                  <span className="ml-1">{note.type?.caption}</span>
                </>
              ) : (
                <>
                  <DownloadIcon />
                  <span className="ml-1">Descarregar</span>
                </>
              )}
            </button>
          </a>
          {false && (
            <Tab.Container
              defaultActiveKey="first"
              id="uncontrolled-tab-example"
              className="mb-3"
            >
              {!!note.content && (
                <Nav variant="pills" className="flex-row">
                  <Nav.Item>
                    <Nav.Link eventKey="first">Detalhes</Nav.Link>
                  </Nav.Item>
                  <Nav.Item>
                    <Nav.Link eventKey="second">Conteúdo</Nav.Link>
                  </Nav.Item>
                </Nav>
              )}
              <Tab.Content>
                <Tab.Pane eventKey="first">
                  <h1>Tab1</h1>
                </Tab.Pane>
                <Tab.Pane eventKey="second">
                  <h1>Tab2</h1>
                </Tab.Pane>
              </Tab.Content>
            </Tab.Container>
          )}
          <div>
            <dl>
              {note.school_year?.year_begin && note.school_year?.year_end && (
                <>
                  <dt className="small font-weight-bold">
                    <span className="mr-1">Ano letivo</span>
                    {/* <FontAwesomeIcon
                      className="link mr-1 text-primary"
                      icon={faFilter}
                      size={"1x"}
                      title="Filtrar por ano letivo"
                      onClick={() => {
                        setSelYear(note.school_year?.year_id);
                        setSelPage(1);
                      }}
                    /> */}
                  </dt>
                  <dd>
                    {note.school_year?.year_begin}/{note.school_year?.year_end}
                  </dd>
                </>
              )}
              {!!note.subject?.name && (
                <>
                  <dt className="small font-weight-bold">
                    <span className="mr-1">Cadeira</span>
                    {/* <FontAwesomeIcon
                      className="link mr-1 text-primary"
                      icon={faFilter}
                      size={"1x"}
                      title="Filtrar por cadeira"
                      onClick={() => {
                        setSelectedSubject(note.subjectId);
                        setSelPage(1);
                      }}
                    /> */}
                  </dt>
                  <dd>{note.subject?.name}</dd>
                </>
              )}
              {!!note.author?.name && (
                <>
                  <dt className="small font-weight-bold">
                    <span className="mr-1">Autor</span>
                    {/* <FontAwesomeIcon
                      className="link mr-1 text-primary"
                      icon={faFilter}
                      size={"1x"}
                      title="Filtrar por autor"
                      onClick={() => {
                        setSelStudent(note.authorId);
                        setSelPage(1);
                      }}
                    /> */}
                  </dt>
                  <dd>{titleCase(note.author?.name)}</dd>
                </>
              )}
              {!!note.teacher?.name && (
                <>
                  <dt className="small font-weight-bold">
                    <span className="mr-1">
                      <span className="mr-1">Docente</span>
                      {/* <FontAwesomeIcon
                        className="link mr-1 text-primary"
                        icon={faFilter}
                        size={"1x"}
                        title="Filtrar por docente"
                        onClick={() => {
                          setSelTeacher(note.teacher?.id);
                          setSelPage(1);
                        }}
                      /> */}
                    </span>
                    {note.teacher?.personal_page && (
                      <a
                        title="Perfil do docente ua.pt"
                        href={note.teacher?.personal_page}
                        target="_blank"
                        rel="noreferrer"
                      >
                        {/* <FontAwesomeIcon
                          className="mr-3 text-primary"
                          icon={faInfoCircle}
                          size={"1x"}
                        /> */}
                      </a>
                    )}
                  </dt>
                  <dd>{note.teacher?.name}</dd>
                </>
              )}
              {!!(note.content || note.size) && (
                <div className="file-content">
                  <dt className="small font-weight-bold">
                    Conteúdo
                    {!!note.size && (
                      <small className="ml-1">({note.size} MB)</small>
                    )}
                  </dt>
                  {!!note.content && (
                    <dd>{parse(`${note.content?.replace("\n", "<br/>")}`)}</dd>
                  )}
                </div>
              )}
            </dl>
          </div>
        </>
      )}
    </div>
  );
};

export default Details;
