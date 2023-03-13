import React, { useState, useEffect } from "react";
import { Tab, Nav, Spinner } from "react-bootstrap";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faTh,
  faThList,
  faTimes,
  faShareAlt,
} from "@fortawesome/free-solid-svg-icons";
import ListView from "./ListView";
import GridView from "./GridView";
import PageNav from "../../components/PageNav";
import Alert from "../../components/Alert";
import Details from "./Details";
import Typist from "react-typist";
import CheckboxFilter from "components/CheckboxFilter";
import data from "./data";

import Autocomplete from "components/Autocomplete";

import service from "services/NEIService";



const Notes = () => {
  const [categories, setCategories] = useState(
    data.categories.map((c) => ({ ...c, checked: true }))
  );

  // Grid view selected note
  const [selectedNote, setSelectedNote] = useState(null);

  // useStates and other variables
  const [notes, setNotes] = useState([]);

  const [filters, setFilters] = useState([]);
  const [activeFilters, setActiveFilters] = useState([]);

  const [subjects, setSubjects] = useState([]); // todos os subjects
  const [years, setYears] = useState([]);
  const [student, setStudents] = useState([]);
  const [teachers, setTeachers] = useState([]);

  const [selectedSubject, setSelectedSubject] = useState("");
  const [selYear, setSelYear] = useState("");
  const [selStudent, setSelStudent] = useState("");
  const [selTeacher, setSelTeacher] = useState("");

  const [pageNumber, setPageNumber] = useState(1);
  const [selPage, setSelPage] = useState(1);

  const [shownYear, setShownYear] = useState();
  const [shownSubj, setShownSubj] = useState();
  const [shownAuth, setShownAuth] = useState();
  const [shownTeacher, setShownTeacher] = useState();

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
    if (urlParams.get("subject")) setSelectedSubject(urlParams.get("subject"));
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
    setSelectedNote(null);

    const params = {
      school_year: selYear || null,
      subject: selectedSubject || null,
      student: selStudent || null,
      teacher: selTeacher || null,
      category: [],
    };

    for (var i = 0; i < activeFilters.length; i++) {
      const cat = filters.filter((f) => f["name"] == activeFilters[i])[0]["db"];
      params.category.push(cat);
    }

    if (activeFilters.length == 0) {
      setNotes([]);
      setSelPage(1);
      setPageNumber(1);
      setLoading(false);
      return;
    }

    if (params.category.length == 0) {
      setNotes([]);
    } else {
      service
        .getNotes({ ...params, page: selPage, size: 18 })
        .then(({ items, last }) => {
          setNotes(
            items.map((note) => {
              if (note.location.endsWith(".pdf")) {
                note.type = {
                  download_caption: "Descarregar",
                  icon_display: "fas file-pdf",
                  icon_download: "fas cloud-download-alt",
                };
              } else if (note.location.endsWith(".zip")) {
                note.type = {
                  download_caption: "Descarregar",
                  icon_display: "fas folder",
                  icon_download: "fas cloud-download-alt",
                };
              } else if (note.location.startsWith("https://github.com/")) {
                note.type = {
                  download_caption: "Repositório",
                  icon_display: "fab github",
                  icon_download: "fab github",
                };
              } else if (
                note.location.startsWith("https://drive.google.com/")
              ) {
                note.type = {
                  download_caption: "Google Drive",
                  icon_display: "fab google-drive",
                  icon_download: "fab google-drive",
                };
              }
              return note;
            })
          );
          setPageNumber(last || 1);
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
          const x = { value: year, label: year + "-" + (year + 1) };
          if (x.value == selYear) setShownYear(x);
          return x;
        });
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
          const x = { value: subj.paco_code, label: subj.short };
          if (x.value == selectedSubject) setShownSubj(x);
          return x;
        });
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
          const x = { value: t.id, label: t.name };
          if (x.value == selStudent) setShownAuth(x);
          return x;
        });
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
      .getNotesTeachers(params)
      .then((data) => {
        const arr = data.map((t) => {
          const x = { value: t.id, label: t.name };
          if (x.value == selTeacher) setShownTeacher(x);
          return x;
        });
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
    selectedSubject,
    selStudent,
    selYear,
    selPage,
    selTeacher,
  ]);

  useEffect(() => {
    setSelPage(1);
  }, [activeFilters, selectedSubject, selStudent, selYear, selTeacher]);

  // This method allows user to share the filtering parameters through a parameterized URL
  let linkShare = () => {
    // Build URL
    let url = window.location.origin + window.location.pathname + "?";
    if (selYear != "") url += `year=${selYear}&`;
    if (selectedSubject != "") url += `subject=${selectedSubject}&`;
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
  };

  let resetFilters = () => {
    setSelectedSubject("");
    setSelStudent("");
    setSelTeacher("");
    setSelYear("");
    setShownYear("");
    setShownSubj("");
    setShownAuth("");
    setShownTeacher("");
  };

  return (
    <div id="apontamentosPage">
      <div className="flex flex-col mb-5">
        <h2 className="mb-2 text-center">
          <Typist>Apontamentos</Typist>
        </h2>
        <Alert alert={alert} setAlert={setAlert} />
      </div>

      <div className="flex gap-8 mt-4">
        <div className="flex flex-col w-full max-w-[18rem]" lg="4" xl="3">
          {selectedNote && selectedNote.id && (
            <Details
              className="order-lg-0 order-2"
              note_id={selectedNote.id}
              close={() => setSelectedNote(null)}
              setSelYear={setSelYear}
              setSelectedSubject={setSelectedSubject}
              setSelStudent={setSelStudent}
              setSelTeacher={setSelTeacher}
              setSelPage={setSelPage}
              setAlert={setAlert}
            />
          )}

          <div className="flex flex-col gap-4">
            <h4>Filtros</h4>

            <Autocomplete
              items={years.map((y) => y.label)}
              value={selYear}
              onChange={setSelYear}
              placeholder="Ano"
            />
            <Autocomplete
              items={subjects.map((y) => y.label)}
              value={selectedSubject}
              onChange={setSelectedSubject}
              placeholder="Disciplina"
            />
            <Autocomplete
              items={student.map((y) => y.label)}
              value={selStudent}
              onChange={setSelStudent}
              placeholder="Autor"
            />
            <Autocomplete
              items={teachers.map((y) => y.label)}
              value={selTeacher}
              onChange={setSelTeacher}
              placeholder="Professor"
            />
          </div>

          {(selectedSubject || selStudent || selTeacher || selYear) && (
              <div className="flex mb-2 flex-row flex-wrap">
                <button
                  className="rounded-pill btn-outline-primary pill animation btn-sm btn mr-2"
                  onClick={() => linkShare()}
                  title="Copiar link com filtros"
                >
                  <span className="mr-1">Partilhar</span>
                  <FontAwesomeIcon className="link my-auto" icon={faShareAlt} />
                </button>
                <button
                  className="rounded-pill btn-outline-primary pill animation btn-sm btn mr-2"
                  onClick={() => resetFilters()}
                  title="Remover filtros"
                >
                  <span className="mr-1">Limpar</span>
                  <FontAwesomeIcon className="link my-auto" icon={faTimes} />
                </button>
              </div>
            )}

          <CheckboxFilter values={categories} onChange={setCategories} />

          {/* <div className="order-lg-3 order-1">
            <h4 className="mt-3">Categorias</h4>
            <Filters
              accordion={true}
              filterList={filters}
              activeFilters={activeFilters}
              setActiveFilters={setActiveFilters}
              className="mb-5"
              btnClass="btn-sm"
              listClass="flex flex-col"
              allBtnClass="mb-2 p-0 col-12"
            />
          </div> */}
        </div>

        {/* The two views are controlled by a bootstrap tabs component,
         ** using a custom layout. The Nav element contains the buttons that switch
         ** the views, which are specified in each Tab.Pane element.
         */}
        <div className="">
          <Tab.Container
            defaultActiveKey={window.innerWidth >= 992 ? "grid" : "list"}
          >
            <div>
              <Nav onSelect={() => setSelectedNote(null)}>
                <Nav.Item className="mx-lg-0 ml-lg-0 d-none d-lg-block mx-auto">
                  <Nav.Link eventKey="grid" className="h5">
                    <FontAwesomeIcon icon={faTh} />
                    <span className="ml-3">Grid</span>
                  </Nav.Link>
                </Nav.Item>
                <Nav.Item className="mx-lg-0 mr-lg-auto d-none d-lg-block mx-auto">
                  <Nav.Link eventKey="list" className="h5">
                    <FontAwesomeIcon icon={faThList} />
                    <span className="ml-3">List</span>
                  </Nav.Link>
                </Nav.Item>
                <PageNav
                  page={selPage}
                  total={pageNumber}
                  handler={fetchPage}
                  className="mx-lg-0 ml-lg-auto mx-auto"
                ></PageNav>
              </Nav>
            </div>

            <Tab.Content>
              <Tab.Pane eventKey="grid">
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
                    <GridView
                      data={notes}
                      setSelected={setSelectedNote}
                    ></GridView>
                  )}
                </div>
              </Tab.Pane>
              <Tab.Pane eventKey="list">
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
                      setSelectedSubject={setSelectedSubject}
                      setSelStudent={setSelStudent}
                      setSelTeacher={setSelTeacher}
                    ></ListView>
                  )}
                </div>
              </Tab.Pane>
            </Tab.Content>
          </Tab.Container>
          <PageNav
            page={selPage}
            total={pageNumber}
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
