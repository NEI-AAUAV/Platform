import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { vi } from "vitest";
import SportsSidebarAlertDialog from "../../components/SportsSidebar/alertDialog";
import TacaUAService from "../../services/TacaUAService.jsx";

vi.mock("../../components/ui/select.tsx", async () => (await import("../helpers/uiMocks")).selectMock);
vi.mock("../../components/ui/alert-dialog.tsx", async () => (await import("../helpers/uiMocks")).alertDialogMock);
vi.mock("../../services/TacaUAService.jsx", () => ({
  default: { removeModality: vi.fn(), getModalities: vi.fn() },
}));

const m1: any = { id: 1, sport: "Futsal", frame: "Masculino", year: 2025, type: "Coletiva" };
const m2: any = { id: 2, sport: "Futsal", frame: "Feminino", year: 2025, type: "Coletiva" };

function setup(over: any = {}) {
  const props = {
    currentModality: m1,
    modalCurrent: [m1, m2],
    modalModality: m1,
    setData: vi.fn(),
    setModalModality: vi.fn(),
    toast: vi.fn(),
    ...over,
  };
  render(<SportsSidebarAlertDialog {...props} />);
  return props;
}

const confirm = "FutsalMasculino2025";

describe("SportsSidebarAlertDialog", () => {
  beforeEach(() => vi.clearAllMocks());

  it("switches modality through the select", () => {
    const p = setup();
    fireEvent.click(screen.getByTestId("opt-2"));
    expect(p.setModalModality).toHaveBeenCalledWith(m2);
  });

  it("keeps Eliminar disabled until confirmation text matches", () => {
    setup();
    const btn = screen.getByRole("button", { name: "Eliminar" });
    expect(btn).toBeDisabled();
    fireEvent.change(screen.getByPlaceholderText(confirm), { target: { value: confirm } });
    expect(btn).toBeEnabled();
    fireEvent.click(screen.getByText("Cancelar"));
    expect(btn).toBeDisabled();
  });

  it("removes modality and refreshes data", async () => {
    (TacaUAService.removeModality as any).mockResolvedValue({});
    (TacaUAService.getModalities as any).mockResolvedValue([m1]);
    const p = setup();
    fireEvent.change(screen.getByPlaceholderText(confirm), { target: { value: confirm } });
    fireEvent.click(screen.getByRole("button", { name: "Eliminar" }));
    await waitFor(() => expect(p.setData).toHaveBeenCalledWith([m1]));
    expect(TacaUAService.removeModality).toHaveBeenCalledWith(1);
    expect(p.toast).toHaveBeenCalledWith({ description: "Modalidade removida com sucesso." });
  });

  it("toasts error when removal fails", async () => {
    (TacaUAService.removeModality as any).mockRejectedValue(new Error("boom"));
    const p = setup();
    fireEvent.change(screen.getByPlaceholderText(confirm), { target: { value: confirm } });
    fireEvent.click(screen.getByRole("button", { name: "Eliminar" }));
    await waitFor(() =>
      expect(p.toast).toHaveBeenCalledWith(expect.objectContaining({ description: "boom", variant: "destructive" }))
    );
    expect(p.setData).not.toHaveBeenCalled();
  });

  it("toasts error when refetch fails", async () => {
    (TacaUAService.removeModality as any).mockResolvedValue({});
    (TacaUAService.getModalities as any).mockRejectedValue(new Error("nope"));
    const p = setup();
    fireEvent.change(screen.getByPlaceholderText(confirm), { target: { value: confirm } });
    fireEvent.click(screen.getByRole("button", { name: "Eliminar" }));
    await waitFor(() =>
      expect(p.toast).toHaveBeenCalledWith(expect.objectContaining({ title: "Erro a obter dados." }))
    );
  });
});
