import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

const svc = vi.hoisted(() => ({ deleteUser: vi.fn(), getUserChildren: vi.fn() }));
const toast = vi.hoisted(() => vi.fn());
vi.mock("../../../../services/FamilyService", () => ({ default: svc }));
vi.mock("../../../../components/ui/use-toast", () => ({ useToast: () => ({ toast }) }));
vi.mock("../../../../components/Family", () => ({
  UserListDisplay: ({ users }) => <ul>{users.map((u) => <li key={u.id}>{u.name}</li>)}</ul>,
}));

const { default: BulkDeleteModal } = await import(
  "../../../../pages/settings/Family/BulkDeleteModal"
);

const USERS = [
  { id: 1, name: "Ana Silva" },
  { id: 2, name: "Bruno Costa" },
];

function setup(props = {}) {
  const onClose = vi.fn();
  const onComplete = vi.fn();
  render(
    <BulkDeleteModal isOpen onClose={onClose} onComplete={onComplete} selectedUsers={USERS} {...props} />
  );
  return { onClose, onComplete };
}

const deleteButton = () => screen.getByRole("button", { name: /eliminar \d+ membro/i });
const confirm = (text) => userEvent.type(screen.getByPlaceholderText("ELIMINAR"), text);

beforeEach(() => {
  svc.deleteUser.mockReset().mockResolvedValue(undefined);
  svc.getUserChildren.mockReset().mockResolvedValue([]);
  toast.mockReset();
  vi.spyOn(console, "error").mockImplementation(() => {});
  vi.spyOn(console, "debug").mockImplementation(() => {});
});

describe("BulkDeleteModal", () => {
  it("lists the members that will be deleted", () => {
    setup();

    expect(screen.getByText("2 membro(s) serão eliminados:")).toBeInTheDocument();
    expect(screen.getByText("Ana Silva")).toBeInTheDocument();
    expect(screen.getByText("Bruno Costa")).toBeInTheDocument();
  });

  it("keeps deletion disabled until the confirmation word is typed", async () => {
    setup();
    expect(deleteButton()).toBeDisabled();

    await confirm("elimin");
    expect(deleteButton()).toBeDisabled();

    await confirm("ar"); // case-insensitive full word
    expect(deleteButton()).toBeEnabled();
  });

  it("never calls the API without confirmation", async () => {
    setup();

    await userEvent.click(deleteButton());

    expect(svc.deleteUser).not.toHaveBeenCalled();
  });

  it("deletes every member, then completes and closes", async () => {
    const { onClose, onComplete } = setup();
    await confirm("ELIMINAR");

    await userEvent.click(deleteButton());

    await waitFor(() => expect(svc.deleteUser).toHaveBeenCalledTimes(2));
    expect(svc.deleteUser).toHaveBeenCalledWith(1);
    expect(svc.deleteUser).toHaveBeenCalledWith(2);
    await waitFor(() => expect(onComplete).toHaveBeenCalledTimes(1), { timeout: 3000 });
    expect(onClose).toHaveBeenCalledTimes(1);
    expect(toast).toHaveBeenCalledWith(
      expect.objectContaining({ title: "Eliminação em massa concluída" })
    );
  });

  it("reports which members failed and does not close automatically", async () => {
    svc.deleteUser.mockImplementation(async (id) => {
      if (id === 2) throw { response: { data: { detail: "Cannot delete user with 3 children" } } };
    });
    const { onClose, onComplete } = setup();
    await confirm("ELIMINAR");

    await userEvent.click(deleteButton());

    expect(await screen.findByText("Alguns membros não foram eliminados:")).toBeInTheDocument();
    expect(screen.getByText("Bruno Costa: Cannot delete user with 3 children")).toBeInTheDocument();
    expect(screen.queryByText("Ana Silva: Cannot delete user with 3 children")).not.toBeInTheDocument();
    expect(toast).toHaveBeenCalledWith(expect.objectContaining({ variant: "destructive" }));
    expect(onClose).not.toHaveBeenCalled();
    expect(onComplete).not.toHaveBeenCalled();
  });

  it("'Concluir' after partial failure refreshes the list and closes", async () => {
    svc.deleteUser.mockRejectedValue(new Error("boom"));
    const { onClose, onComplete } = setup();
    await confirm("ELIMINAR");
    await userEvent.click(deleteButton());

    await userEvent.click(await screen.findByRole("button", { name: "Concluir" }));

    expect(onComplete).toHaveBeenCalledTimes(1);
    expect(onClose).toHaveBeenCalledTimes(1);
  });

  it("warns about members that still have children (orphans)", async () => {
    svc.getUserChildren.mockImplementation(async (id) =>
      id === 1 ? [{ name: "A" }, { name: "B" }, { name: "C" }, { name: "D" }] : []
    );
    setup();

    expect(await screen.findByText(/alguns membros têm pedaços/i)).toBeInTheDocument();
    expect(screen.getByText(/Ana Silva: 4 pedaço\(s\)/)).toHaveTextContent("(A, B, C...)");
    expect(screen.queryByText(/Bruno Costa: \d+ pedaço/)).not.toBeInTheDocument();
  });

  it("still allows deletion when the orphan check fails", async () => {
    svc.getUserChildren.mockRejectedValue(new Error("down"));
    setup();
    await confirm("ELIMINAR");

    expect(screen.queryByText(/têm pedaços/i)).not.toBeInTheDocument();
    expect(deleteButton()).toBeEnabled();
  });

  it("only checks the first 10 selected members for orphans", async () => {
    const many = Array.from({ length: 15 }, (_, i) => ({ id: i + 1, name: `User ${i + 1}` }));
    setup({ selectedUsers: many });

    await waitFor(() => expect(svc.getUserChildren).toHaveBeenCalledTimes(10));
  });

  it("renders nothing when closed", () => {
    setup({ isOpen: false });

    expect(screen.queryByText("Eliminar Membros")).not.toBeInTheDocument();
    expect(svc.getUserChildren).not.toHaveBeenCalled();
  });
});
