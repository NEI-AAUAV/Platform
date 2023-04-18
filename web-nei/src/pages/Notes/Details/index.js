import React, { useState, useEffect } from "react";
import { Spinner, Nav, Tab } from "react-bootstrap";
import "./index.css";

import parse from "html-react-parser";

import {
  FilePDFIcon,
  FolderZipIcon,
  DownloadIcon,
  OpenInNewIcon,
  CloseIcon,
  FilterIcon,
  InfoIcon,
} from "assets/icons/google";
import { GithubIcon, GoogleDriveIcon } from "assets/icons/social";

import service from "services/NEIService";

const Details = ({
  note_id,
  close,
  setSelSubject,
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
    if (document.getElementById("notes") != null) {
      document.getElementById("notes").scrollIntoView({ behavior: "smooth" });
    }
  }, [note]);

  return (
    <div className={`flex flex-col ${className}`}>
      {!!loading ? (
        <Spinner
          animation="grow"
          variant="primary"
          className="mx-auto mt-3"
          title="A carregar..."
        />
      ) : (
        <div className="rounded-xl border border-base-content/10 bg-base-200 p-5">
          <div className="flex flex-row justify-between">
            <h4>{note.name}</h4>
            <button className="btn-ghost btn-sm btn-circle btn" onClick={close}>
              <CloseIcon />
            </button>
          </div>
          <div className="row mx-0 my-3">
            {tags.map((tag, index) => (
              <span
                key={index}
                className={"badge-pill badge mb-1 ml-0 mr-1 " + tag.className}
              >
                {tag.name}
              </span>
            ))}
          </div>
          <a className="btn-sm btn mb-3" href={note.location} target="_blank" rel="noreferrer">
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
          </a>
          {/* <Tab.Container
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
            </Tab.Container> */}
          <div>
            <dl>

              {!!note.year && (
                <>
                  <dt className="mt-1 flex align-center gap-1.5 font-bold">
                    <span>Ano letivo</span>
                    <button
                      className="btn-ghost btn-xs btn-circle btn text-primary"
                      onClick={() => {
                        setSelYear(note.year);
                        setSelPage(1);
                      }}
                    >
                      <FilterIcon />
                    </button>
                  </dt>
                  <dd>
                    {note.year}-{note.year + 1}
                  </dd>
                </>
              )}
              {!!note.subject && (
                <>
                  <dt className="mt-1 flex align-center gap-1.5 font-bold">
                    <span>Cadeira</span>
                    <button
                      className="btn-ghost btn-xs btn-circle btn text-primary"
                      onClick={() => {
                        setSelSubject(note.subject_id);
                        setSelPage(1);
                      }}
                    >
                      <FilterIcon />
                    </button>
                  </dt>
                  <dd>{note.subject?.name}</dd>
                </>
              )}
              {!!note.author && (
                <>
                  <dt className="mt-1 flex align-center gap-1.5 font-bold">
                    <span>Autor</span>
                    <button
                      className="btn-ghost btn-xs btn-circle btn text-primary"
                      onClick={() => {
                        setSelStudent(note.author_id);
                        setSelPage(1);
                      }}
                    >
                      <FilterIcon />
                    </button>
                  </dt>
                  <dd>
                    {note.author?.name} {note.author?.surname}
                  </dd>
                </>
              )}
              {!!note.teacher && (
                <>
                  <dt className="mt-1 flex gap-1 font-bold">
                    <span>Docente</span>
                    <button
                      className="btn-ghost btn-xs btn-circle btn text-primary"
                      onClick={() => {
                        setSelTeacher(note.teacher_id);
                        setSelPage(1);
                      }}
                    >
                      <FilterIcon />
                    </button>
                    {note.teacher?.personal_page && (
                      <a
                        title="Perfil do docente ua.pt"
                        className="btn-ghost btn-xs btn-circle btn text-primary"
                        href={note.teacher?.personal_page}
                        target="_blank"
                        rel="noreferrer"
                      >
                        <InfoIcon />
                      </a>
                    )}
                  </dt>
                  <dd>{note.teacher?.name}</dd>
                </>
              )}
              {!!(note.content || note.size) && (
                <div className="file-content">
                  <dt className="mt-1 flex align-center gap-1.5 font-bold">
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
        </div>
      )}
    </div>
  );
};

export default Details;
