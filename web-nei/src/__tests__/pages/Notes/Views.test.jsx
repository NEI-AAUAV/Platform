import { render, screen, fireEvent } from "@testing-library/react";
import { MemoryRouter } from "react-router-dom";
import { vi } from "vitest";
import ListView from "../../../pages/Notes/ListView";
import GridView from "../../../pages/Notes/GridView";
import NoteCard from "../../../pages/Notes/NoteCard";

const recent = new Date().toISOString();
const old = "2015-01-01T00:00:00Z";

const fullNote = {
  id: 1,
  name: "Resumo FP",
  created_at: recent,
  location: "https://files.example/a.pdf",
  year: 2023,
  subject: { name: "Fundamentos", short: "FP" },
  author: { name: "ana", surname: "Silva", gender: "F" },
  teacher: { name: "Prof Rui", page: "https://ua.pt/rui" },
  school_year: { year_begin: 2023, year_end: 2024 },
  summary: "1",
  tests: "1",
  bibliography: "1",
  slides: "1",
  exercises: "1",
  projects: "1",
  notebook: "1",
  type: { download: false, caption: "Abrir" },
};

const plainNote = {
  id: 2,
  name: "Slides",
  created_at: old,
  location: "https://files.example/b.pdf",
  type: { download: true },
  bibliography: "1",
};

describe("ListView", () => {
  it("renders header and rows with every tag", () => {
    const { container } = render(<ListView data={[fullNote]} />);
    expect(screen.getByText("Ficheiro")).toBeInTheDocument();
    expect(screen.getByText("Resumo FP")).toBeInTheDocument();
    for (const t of ["Novo!", "Resumos", "Testes e exames", "Bibliografia", "Slides", "Exercícios", "Projetos", "Caderno"]) {
      expect(screen.getByText(t)).toBeInTheDocument();
    }
    expect(screen.getByText("Ana")).toBeInTheDocument(); // titleCase
    expect(screen.getByText("2023/2024")).toBeInTheDocument();
    expect(screen.getByText("Abrir")).toBeInTheDocument();
    expect(container.querySelector('a[title="Perfil do docente ua.pt"]')).toHaveAttribute("href", "https://ua.pt/rui");
  });

  it("renders minimal rows with download button and no optional blocks", () => {
    render(<ListView data={[plainNote]} />);
    expect(screen.getByText("Descarregar")).toBeInTheDocument();
    expect(screen.queryByText("Novo!")).not.toBeInTheDocument();
    expect(screen.queryByText("Autor", { selector: "span" })).not.toBeInTheDocument();
    expect(screen.queryByText("Ano letivo")).not.toBeInTheDocument();
    expect(screen.queryByText("Docente")).not.toBeInTheDocument();
  });

  it("renders empty list", () => {
    render(<ListView data={[]} />);
    expect(screen.getByText("Cadeira")).toBeInTheDocument();
  });
});

describe("NoteCard", () => {
  const wrap = (ui) => render(<MemoryRouter>{ui}</MemoryRouter>);

  it("shows subject, years, author tooltip, name and tags", () => {
    wrap(<NoteCard note={fullNote} link="/n/1" Icon={(p) => <i data-testid="ico" {...p} />} />);
    expect(screen.getByText("FP")).toBeInTheDocument();
    expect(screen.getByText("2023-2024")).toBeInTheDocument();
    expect(screen.getByTestId("ico")).toBeInTheDocument();
    expect(screen.getByAltText("Perfil")).toBeInTheDocument();
    expect(screen.getByText("Novo")).toBeInTheDocument();
    expect(screen.getByText("Caderno")).toBeInTheDocument();
    expect(screen.getByText("Resumo FP")).toBeInTheDocument();
  });

  it("omits optional parts and fires onClick", () => {
    const onClick = vi.fn();
    wrap(<NoteCard note={{ id: 3, name: "X", created_at: old }} link="/n/3" onClick={onClick} title="t" />);
    expect(screen.queryByAltText("Perfil")).not.toBeInTheDocument();
    expect(screen.queryByText("Novo")).not.toBeInTheDocument();
    fireEvent.click(screen.getByText("X"));
    expect(onClick).toHaveBeenCalled();
  });

  it("uses author image when present", () => {
    wrap(
      <NoteCard
        note={{ ...plainNote, author: { name: "a", surname: "b", image: "http://img/x.png" } }}
        link="/n/2"
      />
    );
    expect(screen.getByAltText("Perfil")).toHaveAttribute("src", "http://img/x.png");
  });
});

describe("GridView", () => {
  it("renders a card per note and selects on click", () => {
    const setSelected = vi.fn();
    render(
      <MemoryRouter>
        <GridView data={[fullNote, plainNote]} setSelected={setSelected} />
      </MemoryRouter>
    );
    fireEvent.click(screen.getByText("Slides"));
    expect(setSelected).toHaveBeenCalledWith(plainNote);
    expect(screen.getByText("Resumo FP")).toBeInTheDocument();
  });
});
