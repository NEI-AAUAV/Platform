import React, { useState, useEffect, useCallback } from "react";
import { Spinner } from "react-bootstrap";
import { motion, AnimatePresence } from "framer-motion";

import ListView from "./ListView";
import GridView from "./GridView";
import PageNav from "../../components/PageNav";
import Alert from "../../components/Alert";
import Details from "./Details";
import Typist from "react-typist";
import CheckboxDropdown from "components/CheckboxDropdown";
import data from "./data";

import Autocomplete from "components/Autocomplete";

import config from "config";
import service from "services/NEIService";
import {
  FilterIcon,
  FilePDFIcon,
  FolderZipIcon,
  GridViewIcon,
  ViewListIcon,
  ShareIcon,
  CloseIcon,
} from "assets/icons/google";
import { GithubIcon, GoogleDriveIcon } from "assets/icons/social";
import { TabsButton } from "components";
import { debounce } from "lodash";

const Views = {
  GRID: 0,
  LIST: 1,
};

export function Component() {
  const [view, setView] = useState(Views.GRID);
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

  const debouncedSetCategories = useCallback(debounce(setCategories, 300), []);

  const fetchPage = (pageNum) => {
    setSelPage(pageNum);
  };

  // When page loads
  useEffect(() => {
    // 1. Load category filters (static)
    setFilters(categories);
    setActiveFilters(categories.map((c) => c.name));
    // 2. Check if there are filtering parameters on URL
    // Get parameters and apply to filters
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get("year")) setSelYear(+urlParams.get("year"));
    if (urlParams.get("subject")) setSelSubject(+urlParams.get("subject"));
    if (urlParams.get("author")) setSelStudent(+urlParams.get("author"));
    if (urlParams.get("teacher")) setSelTeacher(+urlParams.get("teacher"));
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

    const selCategories = categories
      .filter((c) => c.checked)
      .map((c) => c.name);
    const selCategoriesKeys = Object.entries(data.categories)
      .filter(([k, v]) => selCategories.includes(v.name))
      .map(([k]) => k);

    const params = {
      year: selYear || null,
      subject: selSubject || null,
      student: selStudent || null,
      teacher: selTeacher || null,
      curricular_year: selCurricularYear || null,
      category: selCategoriesKeys,
    };

    for (let activeFilter of activeFilters) {
      const cat = filters.filter((f) => f["name"] == activeFilter)[0]["db"];
      params.category.push(cat);
    }

    if (activeFilters.length === 0) {
      setNotes([]);
      setSelPage(1);
      setPage(1);
      setLoading(false);
      return;
    }

    if (params.category.length === 0) {
      setNotes([]);
    } else {
      service
        .getNotes({ ...params, page: selPage, size: 18 })
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
        const arr = data
          .map((year) => {
            const x = { key: year, label: year + "-" + (year + 1) };
            return x;
          })
          .sort((a, b) => b?.label?.localeCompare(a?.label));
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
        const arr = data
          .map((subj) => {
            const x = { key: subj.code, label: subj.short };
            return x;
          })
          .sort((a, b) => a?.label?.localeCompare(b?.label));
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
        const arr = data
          .map((t) => {
            const x = { key: t.id, label: t.name + " " + t.surname };
            return x;
          })
          .sort((a, b) => a?.label?.localeCompare(b?.label));
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
        const arr = data
          .map((year) => {
            const x = { key: year, label: `${year}º ano` };
            return x;
          })
          .sort((a, b) => a?.label?.localeCompare(b?.label));
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
        const arr = data
          .map((t) => {
            const x = { key: t.id, label: t.name };
            return x;
          })
          .sort((a, b) => a?.label?.localeCompare(b?.label));
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
  }, [
    activeFilters,
    selSubject,
    selStudent,
    selYear,
    selPage,
    selTeacher,
    selCurricularYear,
    categories,
  ]);

  useEffect(() => {
    setSelPage(1);
  }, [
    activeFilters,
    selSubject,
    selStudent,
    selYear,
    selTeacher,
    selCurricularYear,
  ]);

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
      for (let activeFilter of activeFilters) {
        url +=
          "category=" +
          filters.name((f) => f["filter"] == activeFilter)[0]["db"] +
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
    <div id="notes">
      <div className="mb-5 flex flex-col">
        <h2 className="mb-2 text-center">
          <Typist>Apontamentos</Typist>
        </h2>
        <Alert alert={alert} setAlert={setAlert} />
      </div>

      <div className="mt-4 flex flex-col gap-8 sm:flex-row">
        <div className="mx-auto flex w-72 flex-col">
          <div className="sticky top-[5rem] w-[inherit]">
            <div className="flex flex-col gap-4">
              <div className="mt-1 flex h-10 justify-around align-top">
                {(selSubject || selStudent || selTeacher || selYear) && (
                  <>
                    <button
                      className="btn-sm btn gap-2"
                      onClick={() => linkShare()}
                      title="Copiar link com filtros"
                    >
                      Partilhar
                      <ShareIcon />
                    </button>
                    <button
                      className="btn-sm btn gap-2"
                      onClick={() => resetFilters()}
                      title="Remover filtros"
                    >
                      Limpar
                      <CloseIcon />
                    </button>
                  </>
                )}
              </div>

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

            <AnimatePresence initial={false}>
              {selNote && selNote.id && (
                <motion.div
                  key={selNote.id}
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  exit={{ opacity: 0 }}
                >
                  <Details
                    className="mt-8"
                    note_id={selNote.id}
                    close={() => setSelNote(null)}
                    setSelYear={setSelYear}
                    setSelSubject={setSelSubject}
                    setSelStudent={setSelStudent}
                    setSelTeacher={setSelTeacher}
                    setSelPage={setSelPage}
                    setAlert={setAlert}
                  />
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        </div>

        {/* The two views are controlled by a bootstrap tabs component,
         ** using a custom layout. The Nav element contains the buttons that switch
         ** the views, which are specified in each Tab.Pane element.
         */}

        <div className="flex grow flex-col gap-5">
          <div className="flex justify-between">
            <TabsButton
              tabs={[<GridViewIcon />] + !config.PRODUCTION ? [<ViewListIcon />] : []}
              selected={view}
              setSelected={setView}
            />
            <CheckboxDropdown
              className="btn-sm gap-2"
              values={categories}
              onChange={debouncedSetCategories}
            >
              Categorias <FilterIcon />
            </CheckboxDropdown>
          </div>

          <div>
            {view === 0 && (
              <div className="flex justify-center">
                {loading ? (
                  <Spinner
                    animation="grow"
                    variant="primary"
                    className="mx-auto mt-3"
                    title="A carregar..."
                  />
                ) : notes.length == 0 ? (
                  <div>
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
            {
              view === Views.LIST && "Uhh ainda não temos isto feito"
              // TODO: meter isto em tailwind
              // (
              //   <div className="flex flex-col">
              //     {!!loading ? (
              //       <Spinner
              //         animation="grow"
              //         variant="primary"
              //         className="mx-auto mt-3"
              //         title="A carregar..."
              //       />
              //     ) : notes.length === 0 ? (
              //       <div sm={12}>
              //         <h3 className="mt-3 text-center">
              //           Nenhum apontamento encontrado
              //         </h3>
              //         <h4 className="text-center">
              //           Tente definir filtros menos restritivos
              //         </h4>
              //       </div>
              //     ) : (
              //       <ListView
              //         data={notes}
              //         setSelYear={setSelYear}
              //         setSelSubject={setSelSubject}
              //         setSelStudent={setSelStudent}
              //         setSelTeacher={setSelTeacher}
              //       ></ListView>
              //     )}
              //   </div>
              // )
            }
          </div>
        </div>
      </div>
      <PageNav
        numPages={page}
        currentPage={selPage}
        handler={fetchPage}
        className="mx-auto mt-10"
      ></PageNav>
      <div className="card mx-auto mt-10 max-w-4xl bg-base-200/80 px-16 py-8 text-center shadow-md">
        <h3>
          Foi graças a pessoas como tu que esta página se tornou possível!
        </h3>

        <div>
          <p className="m-0">
            O nosso agradecimento aos que mais contribuiram.
          </p>

          <div>
            <div className="mx-auto my-3">
              <h4>Diogo Silva</h4>
              <div>
                <a className="link-primary link" href={"/notes?author=36"}>
                  Os seus apontamentos no site do NEI
                </a>
                <br />
                <a
                  href="https://resumosdeinformatica.netlify.app/"
                  target="_blank"
                  className="link-primary link"
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
          <a className="link link-hover" href="mailto:nei@aauav.pt" target="_blank" rel="noreferrer">nei@aauav.pt</a>. Contamos com o teu
          apoio!
        </p>
      </div>
    </div>
  );
}
