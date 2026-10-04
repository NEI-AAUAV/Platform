import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

const svc = vi.hoisted(() => ({
  getCourses: vi.fn(),
  assignRole: vi.fn(),
  updateUser: vi.fn(),
}));
const toast = vi.hoisted(() => vi.fn());
vi.mock("../../../../services/FamilyService", () => ({ default: svc }));
vi.mock("../../../../components/ui/use-toast", () => ({ useToast: () => ({ toast }) }));
vi.mock("../../../../components/Family", () => ({
  UserListDisplay: ({ users }) => <ul>{users.map((u) => <li key={u.id}>{u.name}</li>)}</ul>,
  RolePickerModal: ({ isOpen, onSelect }) =>
    isOpen ? (
      <button type="button" onClick={() => onSelect({ id: ".1.2.", name: "Mestre" })}>
        pick-role
      </button>
    ) : null,
}));

const { default: BulkEditModal } = await import("../../../../pages/settings/Family/BulkEditModal");

const USERS = [
  { id: 1, name: "Ana Silva", start_year: 18, patrao_id: null },
  { id: 2, name: "Bruno Costa", start_year: 19, patrao_id: 1 },
];
const THIS_YEAR = new Date().getFullYear() - 2000;

function setup(props = {}) {
  const onClose = vi.fn();
  const onComplete = vi.fn();
  render(<BulkEditModal isOpen onClose={onClose} onComplete={onComplete} selectedUsers={USERS} {...props} />);
  return { onClose, onComplete };
}

const apply = () => screen.getByRole("button", { name: /aplicar a \d+ membro/i });

beforeEach(() => {
  svc.getCourses.mockReset().mockResolvedValue({ items: [{ id: 7, short: "LEI", name: "Eng. Informática" }] });
  svc.assignRole.mockReset().mockResolvedValue({});
  svc.updateUser.mockReset().mockResolvedValue({});
  toast.mockReset();
  vi.spyOn(console, "error").mockImplementation(() => {});
});

describe("BulkEditModal", () => {
  it("shows how many members are selected and starts on 'add insignia'", () => {
    setup();

    expect(screen.getByText("2 membro(s) selecionado(s)")).toBeInTheDocument();
    expect(screen.getByText(/adicionar uma insígnia a todos/i)).toBeInTheDocument();
  });

  it("cannot apply 'add insignia' until an insignia is chosen", async () => {
    setup();
    expect(apply()).toBeDisabled();

    await userEvent.click(screen.getByLabelText("Insígnia"));
    await userEvent.click(await screen.findByRole("button", { name: "pick-role" }));

    expect(apply()).toBeEnabled();
    expect(screen.getByText("Mestre")).toBeInTheDocument();
  });

  it("assigns the chosen insignia and year to every member", async () => {
    const { onComplete, onClose } = setup();
    await userEvent.click(screen.getByLabelText("Insígnia"));
    await userEvent.click(await screen.findByRole("button", { name: "pick-role" }));
    const year = screen.getByLabelText("Ano do mandato");
    await userEvent.clear(year);
    await userEvent.type(year, "22");

    await userEvent.click(apply());

    await waitFor(() => expect(svc.assignRole).toHaveBeenCalledTimes(2));
    expect(svc.assignRole).toHaveBeenCalledWith({ user_id: 1, role_id: ".1.2.", year: 22 });
    expect(svc.assignRole).toHaveBeenCalledWith({ user_id: 2, role_id: ".1.2.", year: 22 });
    expect(await screen.findByText("2 membro(s) atualizados com sucesso!")).toBeInTheDocument();
    await waitFor(() => expect(onComplete).toHaveBeenCalled(), { timeout: 4000 });
    expect(onClose).toHaveBeenCalled();
  });

  it("defaults the mandate year to the current year", () => {
    setup();

    expect(screen.getByLabelText("Ano do mandato")).toHaveValue(THIS_YEAR);
  });

  it("sets the same course on every member keeping their other fields", async () => {
    setup();
    await userEvent.click(screen.getByRole("button", { name: /definir curso/i }));
    expect(apply()).toBeDisabled();

    await userEvent.selectOptions(await screen.findByLabelText("Curso"), "7");
    await userEvent.click(apply());

    await waitFor(() => expect(svc.updateUser).toHaveBeenCalledTimes(2));
    expect(svc.updateUser).toHaveBeenCalledWith(1, { ...USERS[0], course_id: 7 });
    expect(svc.updateUser).toHaveBeenCalledWith(2, { ...USERS[1], course_id: 7 });
    expect(svc.assignRole).not.toHaveBeenCalled();
  });

  it("loads the course list when opened", async () => {
    setup();
    await userEvent.click(screen.getByRole("button", { name: /definir curso/i }));

    expect(await screen.findByRole("option", { name: "LEI - Eng. Informática" })).toBeInTheDocument();
    expect(svc.getCourses).toHaveBeenCalledWith({ limit: 100 });
  });

  it("changes the entry year of every member", async () => {
    setup();
    await userEvent.click(screen.getByRole("button", { name: /alterar ano/i }));
    const input = screen.getByLabelText("Novo ano de entrada");
    await userEvent.clear(input);
    await userEvent.type(input, "21");

    await userEvent.click(apply());

    await waitFor(() => expect(svc.updateUser).toHaveBeenCalledTimes(2));
    expect(svc.updateUser).toHaveBeenCalledWith(1, { ...USERS[0], start_year: 21 });
    expect(screen.getByText(/alterar a cor do membro/i)).toBeInTheDocument();
  });

  it("reports partial success with the distinct error messages", async () => {
    svc.updateUser.mockImplementation(async (id) => {
      if (id === 2) throw { response: { data: { detail: "User with nmec 5 already exists" } } };
    });
    setup();
    await userEvent.click(screen.getByRole("button", { name: /alterar ano/i }));

    await userEvent.click(apply());

    expect(await screen.findByText("1 atualizados, 1 com erro.")).toBeInTheDocument();
    expect(screen.getByText("User with nmec 5 already exists")).toBeInTheDocument();
  });

  it("de-duplicates repeated error messages and shows at most three", async () => {
    const four = Array.from({ length: 4 }, (_, i) => ({ id: i + 1, name: `U${i + 1}` }));
    svc.updateUser.mockImplementation(async (id) => {
      throw new Error(id <= 2 ? "same error" : `error ${id}`);
    });
    setup({ selectedUsers: four });
    await userEvent.click(screen.getByRole("button", { name: /alterar ano/i }));

    await userEvent.click(apply());

    expect(await screen.findByText("same error; error 3; error 4")).toBeInTheDocument();
  });

  it("shows only the error when nothing could be updated", async () => {
    svc.updateUser.mockRejectedValue(new Error("server down"));
    setup();
    await userEvent.click(screen.getByRole("button", { name: /alterar ano/i }));

    await userEvent.click(apply());

    expect(await screen.findByText("server down")).toBeInTheDocument();
    expect(screen.queryByText(/atualizados com sucesso/)).not.toBeInTheDocument();
  });

  it("cannot apply with no members selected", () => {
    setup({ selectedUsers: [] });

    expect(apply()).toBeDisabled();
  });

  it("does not load courses while closed", () => {
    setup({ isOpen: false });

    expect(svc.getCourses).not.toHaveBeenCalled();
  });
});
