import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { vi } from "vitest";
import SportsSidebarDialog from "../../components/SportsSidebar/dialog";
import TacaUAService from "../../services/TacaUAService";

const navigate = vi.fn();
vi.mock("react-router-dom", () => ({ useNavigate: () => navigate }));
vi.mock("../../components/ui/select", async () => (await import("../helpers/uiMocks")).selectMock);
vi.mock("../../components/ui/dialog", async () => (await import("../helpers/uiMocks")).dialogMock);
vi.mock("../../components/MaterialSymbol", () => ({ default: () => null }));
vi.mock("../../services/TacaUAService", () => ({
  default: {
    createModality: vi.fn(),
    updateModality: vi.fn(),
    getModalities: vi.fn(),
  },
}));

const m1: any = { id: 1, sport: "Futsal", frame: "Masculino", year: 2025, type: "Coletiva" };
const m2: any = { id: 2, sport: "Futsal", frame: "Feminino", year: 2025, type: "Coletiva" };

function setup(over: any = {}) {
  const props = {
    modalModality: m1,
    modalCurrent: [m1, m2],
    modalType: "add" as const,
    setAddDialogOpen: vi.fn(),
    setData: vi.fn(),
    setModalModality: vi.fn(),
    sportsList: ["Futsal", "Padel"],
    toast: vi.fn(),
    ...over,
  };
  render(<SportsSidebarDialog {...props} />);
  return props;
}

const applyUpdater = (fn: any, base = m1) => fn(base);

describe("SportsSidebarDialog", () => {
  beforeEach(() => vi.clearAllMocks());

  it("renders title per modalType", () => {
    setup({ modalType: "edit" });
    expect(screen.getByText(/Editar modalidade/)).toBeInTheDocument();
  });

  it("selects existing frame", () => {
    const p = setup({ modalType: "edit" });
    fireEvent.click(screen.getByTestId("opt-2"));
    expect(p.setModalModality).toHaveBeenCalledWith(m2);
  });

  it("updates sport, year, type and frame", () => {
    const p = setup();
    fireEvent.click(screen.getByTestId("opt-Padel"));
    expect(applyUpdater(p.setModalModality.mock.calls[0][0]).sport).toBe("Padel");

    fireEvent.change(screen.getByPlaceholderText("Ano"), { target: { value: "2030" } });
    expect(applyUpdater(p.setModalModality.mock.calls[1][0]).year).toBe(2030);

    fireEvent.click(screen.getByText("Pares"));
    expect(applyUpdater(p.setModalModality.mock.calls[2][0]).type).toBe("Pares");

    fireEvent.click(screen.getByText("Misto"));
    expect(applyUpdater(p.setModalModality.mock.calls[3][0]).frame).toBe("Misto");
  });

  it("creates modality, refreshes and navigates", async () => {
    (TacaUAService.createModality as any).mockResolvedValue({ id: 9 });
    (TacaUAService.getModalities as any).mockResolvedValue([m1]);
    const p = setup();
    fireEvent.click(screen.getByRole("button", { name: /Adicionar/ }));
    await waitFor(() => expect(navigate).toHaveBeenCalledWith("/taca-ua/9/games/0"));
    expect(p.setAddDialogOpen).toHaveBeenCalledWith(false);
    expect(p.setData).toHaveBeenCalledWith([m1]);
    expect(p.toast).toHaveBeenCalledWith({ description: "Modalidade adicionada com sucesso." });
  });

  it("edit calls updateModality", async () => {
    (TacaUAService.updateModality as any).mockResolvedValue({ id: 1 });
    (TacaUAService.getModalities as any).mockResolvedValue([]);
    const p = setup({ modalType: "edit" });
    fireEvent.click(screen.getByRole("button", { name: /Editar/ }));
    await waitFor(() => expect(p.setData).toHaveBeenCalled());
    expect(TacaUAService.updateModality).toHaveBeenCalledWith({
      id: 1,
      data: { year: 2025, type: "Coletiva", frame: "Masculino", sport: "Futsal" },
    });
  });

  it("toasts when save fails", async () => {
    (TacaUAService.createModality as any).mockRejectedValue(new Error("fail"));
    const p = setup();
    fireEvent.click(screen.getByRole("button", { name: /Adicionar/ }));
    await waitFor(() =>
      expect(p.toast).toHaveBeenCalledWith(expect.objectContaining({ description: "fail", variant: "destructive" }))
    );
    expect(p.setAddDialogOpen).not.toHaveBeenCalled();
  });

  it("toasts when refetch fails", async () => {
    (TacaUAService.createModality as any).mockResolvedValue({ id: 3 });
    (TacaUAService.getModalities as any).mockRejectedValue(new Error("x"));
    const p = setup();
    fireEvent.click(screen.getByRole("button", { name: /Adicionar/ }));
    await waitFor(() =>
      expect(p.toast).toHaveBeenCalledWith(expect.objectContaining({ title: "Erro a obter dados." }))
    );
  });
});
