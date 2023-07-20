import React, { useState, useEffect } from "react";
import { Spinner } from "react-bootstrap";
import "./index.css";

import {
  FilePDFIcon,
  FolderIcon,
  FolderOpenIcon,
  FolderZipIcon,
  DownloadIcon,
  OpenInNewIcon,
  CloseIcon,
  FilterIcon,
  InfoIcon,
  FileIcon,
} from "assets/icons/google";
import { GithubIcon, GoogleDriveIcon } from "assets/icons/social";

import service from "services/NEIService";
import classNames from "classnames";

const DetailsContents = ({ contents }) => {
  const [contentsTree, setContentsTree] = useState({});

  useEffect(() => {
    if (!contents) {
      return;
    }
    console.log(contents);
    const contentsRoot = {};
    let contentsNode = contentsRoot;

    for (const path of contents) {
      const parts = path.replace(/\/+$/, "").split("/"),
        [fileName] = parts.splice(-1);

      // Navigate through tree path while creating nodes if they don't exist
      for (const part of parts) {
        contentsNode[part] = {
          children: {},
          ...(contentsNode[part] || {}),
          icon: FolderIcon,
          iconOpened: FolderOpenIcon,
        };
        contentsNode = contentsNode[part].children;
      }
      contentsNode[fileName] = {
        icon: FileIcon,
      };
      // Reset node to root
      contentsNode = contentsRoot;
    }
    setContentsTree(contentsRoot);
  }, [contents]);

  if (!contents) {
    return null;
  }

  const Folder = ({ name, icon, iconOpened, children }) => {
    const [isOpened, setIsOpened] = useState(false);

    const Icon = isOpened && iconOpened ? iconOpened : icon;

    return (
      <div className="file-folder">
        <div
          className={classNames(
            "flex gap-2 rounded px-1",
            children
              ? "cursor-pointer hover:bg-base-content/10"
              : "cursor-default"
          )}
          onClick={() => children && setIsOpened(!isOpened)}
        >
          <Icon
            className={classNames(
              "shrink-0",
              children ? "fill-base-content" : "fill-base-content/70"
            )}
          />
          <span className="truncate" title={name}>
            {name}
          </span>
        </div>
        {isOpened && children && (
          <div className="ml-1.5 border-l border-base-content/20 pl-1 group-hover:border-base-content">
            {Object.entries(children).map(([name, props]) => (
              <Folder key={name} name={name} {...props} />
            ))}
          </div>
        )}
      </div>
    );
  };

  return (
    <>
      <dt className="align-center my-1 flex gap-2.5 font-bold">Conteúdo</dt>
      <dd className="group">
        {Object.entries(contentsTree).map(([name, props]) => (
          <Folder key={name} name={name} {...props} />
        ))}
      </dd>
    </>
  );
};

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

  function convertSize(sizeInBytes) {
    const units = ["bytes", "KB", "MB", "GB", "TB"];
    let index = 0;

    while (sizeInBytes >= 1000 && index < units.length - 1) {
      sizeInBytes /= 1000;
      index++;
    }

    return sizeInBytes.toFixed(1) + " " + units[index];
  }

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
            <h4 className="w-52 break-words">{note.name}</h4>
            <button className="btn-ghost btn-sm btn-circle btn" onClick={close}>
              <CloseIcon />
            </button>
          </div>
          <div className="mx-0 my-3 flex-row">
            {tags.map((tag, index) => (
              <span
                key={index}
                className={"badge-pill badge mb-1 ml-0 mr-1 " + tag.className}
              >
                {tag.name}
              </span>
            ))}
          </div>
          <div className="my-6 flex flex-col gap-2 px-4 text-center">
            <a
              className="btn-sm btn"
              href={note.location}
              target="_blank"
              rel="noreferrer"
            >
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
            {!!note.size && (
              <small className="ml-1 font-medium">
                ({convertSize(note.size)})
              </small>
            )}
          </div>
          <div>
            <dl>
              {!!note.year && (
                <>
                  <dt className="align-center mt-1 flex gap-2.5 font-bold">
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
                  <dt className="align-center mt-1 flex gap-2.5 font-bold">
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
                  <dt className="align-center mt-1 flex gap-2.5 font-bold">
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
                  <dt className="mt-1 flex gap-2 font-bold">
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
              <DetailsContents contents={note.contents} />
            </dl>
          </div>
        </div>
      )}
    </div>
  );
};

export default Details;
