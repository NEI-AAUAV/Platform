import { render, screen, fireEvent, waitFor, act } from "@testing-library/react";
import { vi } from "vitest";
import { Component as Notes } from "../../../pages/Notes";
import service from "../../../services/NEIService";

vi.mock("../../../services/NEIService", () => ({
  default: {
    getNotes: vi.fn(),
    getNotesYears: vi.fn(),
    getNotesSubjects: vi.fn(),
    getNotesStudents: vi.fn(),
    getNotesTeachers: vi.fn(),
    getNotesCurricularYears: vi.fn(),
  },
}));
const config = vi.hoisted(() => ({ PRODUCTION: true }));
vi.mock("../../../config", () => ({ default: config }));
vi.mock("lodash", () => ({ debounce: (fn) => fn }));
vi.mock("react-simple-typewriter", () => ({ Typewriter: ({ words }) => <>{words[0]}</> }));
vi.mock("../../../components", () => ({ TabsButton: ({ tabs }) => <div data-testid="tabs-button">{tabs.length}</div> }));
vi.mock("../../../components/Alert", () => ({
  default: ({ alert }) => (alert.text ? <div role="alert">{alert.text}</div> : null),
}));
vi.mock("../../../components/PageNav", () => ({
  default: ({ numPages, handler }) => (
    <button onClick={() => handler(2)}>pages:{numPages}</button>
  ),
}));
vi.mock("../../../components/CheckboxDropdown", () => ({
  default: ({ values, onChange }) => (
    <button onClick={() => onChange(values.map((v) => ({ ...v, checked: false })))}>cats</button>
  ),
}));
vi.mock("../../../components/Autocomplete", () => ({
  default: ({ items, onChange, placeholder }) => (
    <button onClick={() => onChange(items[0]?.key ?? 7)}>{`ac:${placeholder}:${items.length}`}</button>
  ),
}));
vi.mock("../../../pages/Notes/Details", () => ({
  default: ({ note_id, close }) => <button onClick={close}>details-{note_id}</button>,
}));
vi.mock("../../../pages/Notes/GridView", () => ({
  default: ({ data, setSelected }) => (
    <div>
      {data.map((n) => (
        <button key={n.id} onClick={() => setSelected(n)}>{`${n.name}|${n.type?.caption ?? "none"}`}</button>
      ))}
    </div>
  ),
}));

const notes = [
  { id: 1, name: "pdf", location: "a.pdf" },
  { id: 2, name: "zip", location: "a.zip" },
  { id: 3, name: "gh", location: "https://github.com/x/y" },
  { id: 4, name: "drive", location: "https://drive.google.com/z" },
  { id: 5, name: "other", location: "http://x" },
];

function mockAll() {
  service.getNotes.mockResolvedValue({ items: notes.map((n) => ({ ...n })), last: 4 });
  service.getNotesYears.mockResolvedValue([2022, 2023]);
  service.getNotesSubjects.mockResolvedValue([{ code: 1, short: "FP" }, { code: 2, short: "AC" }]);
  service.getNotesStudents.mockResolvedValue([{ id: 3, name: "Ana", surname: "S" }]);
  service.getNotesTeachers.mockResolvedValue([{ id: 4, name: "Rui" }]);
  service.getNotesCurricularYears.mockResolvedValue([1, 2]);
}

describe("Notes page", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    vi.spyOn(console, "error").mockImplementation(() => {});
    window.history.pushState({}, "", "/notes");
  });
  afterEach(() => console.error.mockRestore());

  it("loads notes with resolved types and filter options", async () => {
    mockAll();
    render(<Notes />);
    expect(await screen.findByText("pdf|Descarregar")).toBeInTheDocument();
    expect(screen.getByText("zip|Descarregar")).toBeInTheDocument();
    expect(screen.getByText("gh|Repositório")).toBeInTheDocument();
    expect(screen.getByText("drive|Google Drive")).toBeInTheDocument();
    expect(screen.getByText("other|none")).toBeInTheDocument();
    await screen.findByText("ac:Ano Letivo:2");
    expect(screen.getByText("ac:Disciplina:2")).toBeInTheDocument();
    expect(screen.getByText("pages:4")).toBeInTheDocument();
  });

  it("applies URL params and cleans the URL", async () => {
    mockAll();
    window.history.pushState({}, "", "/notes?year=2023&subject=1&author=3&teacher=4&category=slides");
    render(<Notes />);
    await waitFor(() =>
      expect(service.getNotes).toHaveBeenCalledWith(
        expect.objectContaining({ year: 2023, subject: 1, student: 3, teacher: 4 })
      )
    );
    expect(window.location.search).toBe("");
  });

  it("shows empty message when no notes", async () => {
    mockAll();
    service.getNotes.mockResolvedValue({ items: [], last: 0 });
    render(<Notes />);
    expect(await screen.findByText("Nenhum apontamento encontrado")).toBeInTheDocument();
  });

  it("shows empty list when all categories unchecked", async () => {
    mockAll();
    render(<Notes />);
    await screen.findByText("pdf|Descarregar");
    fireEvent.click(screen.getByText("cats"));
    await waitFor(() => expect(screen.queryByText("pdf|Descarregar")).not.toBeInTheDocument());
  });

  it("alerts when notes request fails", async () => {
    mockAll();
    service.getNotes.mockRejectedValue(new Error("x"));
    render(<Notes />);
    expect(await screen.findByRole("alert")).toHaveTextContent("Ocorreu um erro ao processar o teu pedido");
  });

  it.each([
    ["getNotesYears"],
    ["getNotesSubjects"],
    ["getNotesStudents"],
    ["getNotesCurricularYears"],
    ["getNotesTeachers"],
  ])("resets filters and alerts when %s fails", async (name) => {
    mockAll();
    service[name].mockRejectedValue(new Error("bad"));
    render(<Notes />);
    expect(await screen.findByText(/filtros foram reinicializados|Os seus valores/)).toBeInTheDocument();
  });

  it("opens and closes details when selecting a note", async () => {
    mockAll();
    render(<Notes />);
    fireEvent.click(await screen.findByText("pdf|Descarregar"));
    fireEvent.click(await screen.findByText("details-1"));
    await waitFor(() => expect(screen.queryByText("details-1")).not.toBeInTheDocument());
  });

  it("changes page via PageNav", async () => {
    mockAll();
    render(<Notes />);
    fireEvent.click(await screen.findByText("pages:4"));
    await waitFor(() =>
      expect(service.getNotes).toHaveBeenCalledWith(expect.objectContaining({ page: 2 }))
    );
  });

  it("shows share/clear when a filter is set, copies url and resets", async () => {
    mockAll();
    const writeText = vi.fn().mockResolvedValue();
    Object.defineProperty(navigator, "clipboard", { value: { writeText }, configurable: true });
    render(<Notes />);
    fireEvent.click(await screen.findByText("ac:Disciplina:2"));
    fireEvent.click(await screen.findByTitle("Copiar link com filtros"));
    await waitFor(() => expect(writeText).toHaveBeenCalledWith(expect.stringContaining("subject=")));
    expect(await screen.findByRole("alert")).toHaveTextContent("copiado");
    fireEvent.click(screen.getByTitle("Remover filtros"));
    await waitFor(() => expect(screen.queryByTitle("Remover filtros")).not.toBeInTheDocument());
  });

  it("logs when clipboard copy fails", async () => {
    mockAll();
    const writeText = vi.fn().mockRejectedValue(new Error("deny"));
    Object.defineProperty(navigator, "clipboard", { value: { writeText }, configurable: true });
    render(<Notes />);
    fireEvent.click(await screen.findByText("ac:Autor:1"));
    fireEvent.click(await screen.findByTitle("Copiar link com filtros"));
    await waitFor(() =>
      expect(console.error).toHaveBeenCalledWith("Failed to copy URL to clipboard", expect.any(Error))
    );
  });

  it("shares only the active categories as keys", async () => {
    mockAll();
    const writeText = vi.fn().mockResolvedValue();
    Object.defineProperty(navigator, "clipboard", { value: { writeText }, configurable: true });
    window.history.pushState({}, "", "/notes?category=slides&category=bogus");
    render(<Notes />);
    fireEvent.click(await screen.findByText("ac:Autor:1"));
    fireEvent.click(await screen.findByTitle("Copiar link com filtros"));
    await waitFor(() => expect(writeText).toHaveBeenCalled());
    const url = writeText.mock.calls[0][0];
    expect(url).toContain("category=slides");
    expect(url).not.toContain("bogus");
  });

  it("only offers the list view outside production", async () => {
    mockAll();
    const { unmount } = render(<Notes />);
    expect(screen.getByTestId("tabs-button")).toHaveTextContent("1");
    unmount();
    config.PRODUCTION = false;
    render(<Notes />);
    expect(screen.getByTestId("tabs-button")).toHaveTextContent("2");
    config.PRODUCTION = true;
  });
});
