import React, { useState, useEffect } from "react";
import { Spinner } from "react-bootstrap";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTimes, faShareAlt } from "@fortawesome/free-solid-svg-icons";
import ListView from "./ListView";
import GridView from "./GridView";
import PageNav from "../../components/PageNav";
import Alert from "../../components/Alert";
import Details from "./Details";
import Typist from "react-typist";
import CheckboxFilter from "components/CheckboxFilter";
import data from "./data";

import Autocomplete from "components/Autocomplete";

import classname from "classname";
import service from "services/NEIService";
import {
  FilePDFIcon,
  FolderZipIcon,
  GridViewIcon,
  ViewListIcon,
} from "assets/icons/google";
import { GithubIcon, GoogleDriveIcon } from "assets/icons/social";

const VIEWS = {
  GRID: 1,
  LIST: 2,
};

const Notes = () => {
  const [view, setView] = useState(VIEWS.GRID);
  const [categories, setCategories] = useState(
    Object.values(data.categories).map((c) => ({ ...c, checked: true }))
  );
  const [filters, setFilters] = useState([]);
  const [activeFilters, setActiveFilters] = useState([]);

  const [notes, setNotes] = useState([]);
  const [subjects, setSubjects] = useState([]); // todos os subjects
  const [years, setYears] = useState([]);
  const [students, setStudents] = useState([]);
  const [teachers, setTeachers] = useState([]);
  const [curricularYears, setCurricularYears] = useState([]);
  const [page, setPage] = useState(1);

  // Grid view selected note
  const [selNote, setSelNote] = useState(null);
  const [selSubject, setSelSubject] = useState("");
  const [selYear, setSelYear] = useState("");
  const [selStudent, setSelStudent] = useState("");
  const [selTeacher, setSelTeacher] = useState("");
  const [selCurricularYear, setSelCurricularYear] = useState("");
  const [selPage, setSelPage] = useState(1);

  const [loading, setLoading] = useState(true);

  const [alert, setAlert] = useState({
    type: null,
    text: "",
  });

  const fetchPage = (p_num) => {
    setSelPage(p_num);
  };

  // When page loads
  useEffect(() => {
    // 1. Load category filters (static)
    setFilters(categories);
    setActiveFilters(categories.map((c) => c.name));
    // 2. Check if there are filtering parameters on URL
    // Get parameters and apply to filters
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get("year")) setSelYear(urlParams.get("year"));
    if (urlParams.get("subject")) setSelSubject(urlParams.get("subject"));
    if (urlParams.get("author")) setSelStudent(urlParams.get("author"));
    if (urlParams.get("teacher")) setSelTeacher(urlParams.get("teacher"));
    let active = [];
    urlParams.getAll("category").forEach((categoryParam) => {
      let find = categories.find((f) => f.db == categoryParam);
      if (find) active.push(find.name);
    });
    if (active.length > 0) {
      setActiveFilters(active);
    }
    // Remove data from URL
    var url = document.location.href;
    window.history.pushState({}, "", url.split("?")[0]);
  }, []);

  useEffect(() => {
    setLoading(true);

    // Every time a new call is made to the API, close details
    setSelNote(null);

    const params = {
      year: selYear || null,
      subject: selSubject || null,
      student: selStudent || null,
      teacher: selTeacher || null,
      curricular_year: selCurricularYear || null,
      category: [],
    };
    console.log(params)

    for (var i = 0; i < activeFilters.length; i++) {
      const cat = filters.filter((f) => f["name"] == activeFilters[i])[0]["db"];
      params.category.push(cat);
    }

    if (activeFilters.length == 0) {
      setNotes([]);
      setSelPage(1);
      setPage(1);
      setLoading(false);
      return;
    }

    if (params.category.length == 0) {
      setNotes([]);
    } else {
      service
        .getNotes({ ...params, page: selPage, size: 24 })
        .then(({ items, last }) => {
          setNotes(
            items.map((note) => {
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
              } else if (
                note.location.startsWith("https://drive.google.com/")
              ) {
                note.type = {
                  caption: "Google Drive",
                  Icon: GoogleDriveIcon,
                  download: false,
                };
              }
              return note;
            })
          );
          setPage(last || 1);
          setLoading(false);
        })
        .catch(() => {
          setAlert({
            type: "alert",
            text: "Ocorreu um erro ao processar o teu pedido. Por favor recarrega a página.",
          });
        });
    }

    service
      .getNotesYears(params)
      .then((data) => {
        const arr = data.map((year) => {
          const x = { key: year, label: year + "-" + (year + 1) };
          return x;
        }).sort((a, b) => b?.label?.localeCompare(a?.label));
        setYears(arr);
      })
      .catch(() => {
        console.error('Invalid parameters (no "years" matching)!');
        resetFilters();
        setAlert({
          type: "alert",
          text: "Ocorreu um erro ao processar os teus filtros. Os seus valores foram reinicializados, por favor tenta novamente.",
        });
      });

    service
      .getNotesSubjects(params)
      .then((data) => {
        const arr = data.map((subj) => {
          const x = { key: subj.code, label: subj.short };
          return x;
        }).sort((a, b) => a?.label?.localeCompare(b?.label));
        setSubjects(arr);
      })
      .catch(() => {
        console.error('Invalid parameters (no "subjects" matching)!');
        resetFilters();
        setAlert({
          type: "alert",
          text: "Ocorreu um erro ao processar os teus filtros. Os seus valores foram reinicializados, por favor tenta novamente.",
        });
      });

    service
      .getNotesStudents(params)
      .then((data) => {
        const arr = data.map((t) => {
          const x = { key: t.id, label: t.name + " " + t.surname };
          return x;
        }).sort((a, b) => a?.label?.localeCompare(b?.label));
        setStudents(arr);
      })
      .catch(() => {
        console.error('Invalid parameters (no "students" matching)!');
        resetFilters();
        setAlert({
          type: "alert",
          text: "Ocorreu um erro ao processar os teus filtros. Os seus valores foram reinicializados, por favor tenta novamente.",
        });
      });

    service
      .getNotesCurricularYears(params)
      .then((data) => {
        const arr = data.map((year) => {
          const x = { key: year, label: `${year}º ano` };
          return x;
        }).sort((a, b) => a?.label?.localeCompare(b?.label));
        setCurricularYears(arr);
      })
      .catch(() => {
        console.error('Invalid parameters (no "curricular years" matching)!');
        resetFilters();
        setAlert({
          type: "alert",
          text: "Ocorreu um erro ao processar os teus filtros. Os seus valores foram reinicializados, por favor tenta novamente.",
        });
      });

    service
      .getNotesTeachers(params)
      .then((data) => {
        const arr = data.map((t) => {
          const x = { key: t.id, label: t.name };
          return x;
        }).sort((a, b) => a?.label?.localeCompare(b?.label));
        setTeachers(arr);
      })
      .catch(() => {
        console.error('Invalid parameters (no "teachers" matching)!');
        resetFilters();
        setAlert({
          type: "alert",
          text: "Ocorreu um erro ao processar os teus filtros. Os seus valores foram reinicializados, por favor tenta novamente.",
        });
      });
  }, [activeFilters, selSubject, selStudent, selYear, selPage, selTeacher, selCurricularYear]);

  useEffect(() => {
    setSelPage(1);
  }, [activeFilters, selSubject, selStudent, selYear, selTeacher, selCurricularYear]);

  // This method allows user to share the filtering parameters through a parameterized URL
  function linkShare() {
    // Build URL
    let url = window.location.origin + window.location.pathname + "?";
    if (selYear != "") url += `year=${selYear}&`;
    if (selSubject != "") url += `subject=${selSubject}&`;
    if (selStudent != "") url += `author=${selStudent}&`;
    if (selTeacher != "") url += `teacher=${selTeacher}&`;
    // Only include filters tags if not all selected (because if missing from url, all will be selected by default)
    if (activeFilters.length !== filters.length) {
      for (var i = 0; i < activeFilters.length; i++) {
        url +=
          "category=" +
          filters.name((f) => f["filter"] == activeFilters[i])[0]["db"] +
          "&";
      }
    }
    // Copy to user's clipboard
    navigator.clipboard.writeText(url.slice(0, -1)); // Remove last char (? if no filters or extra &)
    setAlert({
      type: "info",
      text: "O URL foi copiado para a área de transferência! :)",
    });
  }

  function resetFilters() {
    setSelSubject("");
    setSelStudent("");
    setSelTeacher("");
    setSelYear("");
  }

  return (
    <div id="apontamentosPage">
      <div className="mb-5 flex flex-col">
        <h2 className="mb-2 text-center">
          <Typist>Apontamentos</Typist>
        </h2>
        <Alert alert={alert} setAlert={setAlert} />
      </div>

      <div className="mt-4 flex gap-8">
        <div className=" flex w-64 flex-col">
          <div className="sticky top-[5rem] w-[inherit]">
            <div className="flex flex-col gap-4">
              <h4>Filtros</h4>

              <Autocomplete
                items={years}
                value={selYear}
                onChange={setSelYear}
                placeholder="Ano Letivo"
              />
              <Autocomplete
                items={curricularYears}
                value={selCurricularYear}
                onChange={setSelCurricularYear}
                placeholder="Ano Curricular"
              />
              <Autocomplete
                items={subjects}
                value={selSubject}
                onChange={setSelSubject}
                placeholder="Disciplina"
              />
              <Autocomplete
                items={students}
                value={selStudent}
                onChange={setSelStudent}
                placeholder="Autor"
              />
              <Autocomplete
                items={teachers}
                value={selTeacher}
                onChange={setSelTeacher}
                placeholder="Professor"
              />
            </div>

            <div className="w-full flex justify-end">
              {(selSubject || selStudent || selTeacher || selYear) && (
                <div className="mb-2 flex flex-row flex-wrap">
                  <button
                    className="animation btn-sm btn mr-2"
                    onClick={() => linkShare()}
                    title="Copiar link com filtros"
                  >
                    <span className="mr-1">Partilhar</span>
                    <FontAwesomeIcon
                      className="link my-auto"
                      icon={faShareAlt}
                    />
                  </button>
                  <button
                    className="animation btn-sm btn mr-2"
                    onClick={() => resetFilters()}
                    title="Remover filtros"
                  >
                    <span className="mr-1">Limpar</span>
                    <FontAwesomeIcon className="link my-auto" icon={faTimes} />
                  </button>
                </div>
              )}

              <CheckboxFilter
                values={categories}
                onChange={setCategories}
              />
            </div>

            {selNote && selNote.id && (
              <Details
                className="order-lg-0 order-2"
                note_id={selNote.id}
                close={() => setSelNote(null)}
                setSelYear={setSelYear}
                setSelSubject={setSelSubject}
                setSelStudent={setSelStudent}
                setSelTeacher={setSelTeacher}
                setSelPage={setSelPage}
                setAlert={setAlert}
              />
            )}
          </div>
        </div>

        {/* The two views are controlled by a bootstrap tabs component,
         ** using a custom layout. The Nav element contains the buttons that switch
         ** the views, which are specified in each Tab.Pane element.
         */}
        <div className="w-full">
          <div className="flex w-fit items-center space-x-1 rounded-full bg-base-200 py-1 px-2">
            <button
              className={classname(
                "btn-sm btn gap-2 border-none bg-accent py-1",
                view === VIEWS.GRID
                  ? "no-animation shadow hover:bg-accent"
                  : "bg-transparent hover:bg-base-300 hover:opacity-75"
              )}
              onClick={() => setView(VIEWS.GRID)}
            >
              <GridViewIcon />
            </button>
            <button
              className={classname(
                "btn-sm btn gap-2 border-none bg-accent py-1",
                view === VIEWS.LIST
                  ? "no-animation shadow hover:bg-accent"
                  : "bg-transparent hover:bg-base-300 hover:opacity-75"
              )}
              onClick={() => setView(VIEWS.LIST)}
            >
              <ViewListIcon />
            </button>
          </div>

          <div>
            {view === VIEWS.GRID && (
              <div className="flex">
                {loading ? (
                  <Spinner
                    animation="grow"
                    variant="primary"
                    className="mx-auto mt-3"
                    title="A carregar..."
                  />
                ) : notes.length == 0 ? (
                  <div sm={12}>
                    <h3 className="mt-3 text-center">
                      Nenhum apontamento encontrado
                    </h3>
                    <h4 className="text-center">
                      Tente definir filtros menos restritivos
                    </h4>
                  </div>
                ) : (
                  <GridView data={notes} setSelected={setSelNote}></GridView>
                )}
              </div>
            )}
            {view === VIEWS.LIST && (
              <div className="flex flex-col">
                {!!loading ? (
                  <Spinner
                    animation="grow"
                    variant="primary"
                    className="mx-auto mt-3"
                    title="A carregar..."
                  />
                ) : notes.length === 0 ? (
                  <div sm={12}>
                    <h3 className="mt-3 text-center">
                      Nenhum apontamento encontrado
                    </h3>
                    <h4 className="text-center">
                      Tente definir filtros menos restritivos
                    </h4>
                  </div>
                ) : (
                  <ListView
                    data={notes}
                    setSelYear={setSelYear}
                    setSelSubject={setSelSubject}
                    setSelStudent={setSelStudent}
                    setSelTeacher={setSelTeacher}
                  ></ListView>
                )}
              </div>
            )}
          </div>
          <PageNav
            page={selPage}
            total={page}
            handler={fetchPage}
            className="d-lg-none mx-auto mt-3"
          ></PageNav>
        </div>
      </div>
      <div className="card mt-5 bg-base-200/80 text-center shadow-md">
        <h3>
          Foi graças a pessoas como tu que esta página se tornou possível!
        </h3>

        <div>
          <p className="m-0">
            O nosso agradecimento aos que mais contribuiram.
          </p>

          <div>
            <div className="mx-auto my-3">
              <h4 className="">Diogo Silva</h4>
              <div className="small">
                <a className="link" href={"/notes?author=1161"}>
                  Os seus apontamentos no site do NEI
                </a>
                <br />
                <a
                  href="https://resumosdeinformatica.netlify.app/"
                  target="_blank"
                  className="link"
                >
                  Website de apontamentos
                </a>
              </div>
            </div>
          </div>
        </div>
        <p>
          Junta-te a elas e ajuda-nos a manter este repositório atualizado com
          os conteúdos mais recentes. Partilha connosco os teus através do email{" "}
          <a href="mailto:nei@aauav.pt">nei@aauav.pt</a>. Contamos com o teu
          apoio!
        </p>
      </div>
    </div>
  );
};

export default Notes;
