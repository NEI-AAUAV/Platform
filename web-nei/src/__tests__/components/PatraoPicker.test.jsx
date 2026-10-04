import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

const svc = vi.hoisted(() => ({ getUsers: vi.fn() }));
vi.mock("../../services/FamilyService", () => ({ default: svc }));

const { default: PatraoPicker } = await import("../../components/Family/PatraoPicker/PatraoPicker");

const person = (id, over = {}) => ({
  id,
  name: `Person ${id}`,
  sex: "M",
  start_year: 20,
  nmec: 1000 + id,
  ...over,
});
const page = (from, to) => ({ items: Array.from({ length: to - from + 1 }, (_, i) => person(from + i)) });

beforeEach(() => {
  svc.getUsers.mockReset().mockResolvedValue({ items: [person(1), person(2)] });
  vi.spyOn(console, "error").mockImplementation(() => {});
  Element.prototype.scrollIntoView = vi.fn();
});

describe("PatraoPicker", () => {
  it("loads the first page of 50 and lists the members with year and nmec", async () => {
    render(<PatraoPicker selectedPatrao={undefined} onSelect={vi.fn()} />);

    expect(await screen.findByText("Person 1")).toBeInTheDocument();
    expect(svc.getUsers).toHaveBeenCalledWith({ limit: 50, skip: 0 });
    expect(screen.getByText("Person 1").nextSibling).toHaveTextContent("2020 • 1001");
  });

  it("shows a dash when the member has no start year", async () => {
    svc.getUsers.mockResolvedValue({ items: [person(1, { start_year: null, nmec: null })] });
    render(<PatraoPicker onSelect={vi.fn()} />);

    expect((await screen.findByText("Person 1")).nextSibling).toHaveTextContent("-");
  });

  it("selects a member", async () => {
    const onSelect = vi.fn();
    render(<PatraoPicker onSelect={onSelect} />);

    await userEvent.click(await screen.findByText("Person 2"));

    expect(onSelect).toHaveBeenCalledWith(expect.objectContaining({ id: 2 }));
  });

  it("offers 'Sem Patrão' (root member) and selects null", async () => {
    const onSelect = vi.fn();
    render(<PatraoPicker onSelect={onSelect} />);

    await userEvent.click(await screen.findByText("Sem Patrão"));

    expect(onSelect).toHaveBeenCalledWith(null);
  });

  it("can hide the 'Sem Patrão' option", async () => {
    render(<PatraoPicker onSelect={vi.fn()} showNoPatraoOption={false} />);
    await screen.findByText("Person 1");

    expect(screen.queryByText("Sem Patrão")).not.toBeInTheDocument();
  });

  it("marks the current selection", async () => {
    render(<PatraoPicker selectedPatrao={person(2)} onSelect={vi.fn()} />);

    const row = (await screen.findByText("Person 2")).closest("button");

    expect(row).toHaveClass("bg-primary/10");
    expect(screen.getByText("Person 1").closest("button")).not.toHaveClass("bg-primary/10");
  });

  it("marks 'Sem Patrão' when the selection is explicitly null", async () => {
    render(<PatraoPicker selectedPatrao={null} onSelect={vi.fn()} />);

    expect((await screen.findByText("Sem Patrão")).closest("button")).toHaveClass("bg-primary/10");
  });

  it("adds a selected member that is not on the loaded page", async () => {
    render(<PatraoPicker selectedPatrao={person(77)} onSelect={vi.fn()} />);

    expect(await screen.findByText("Person 77")).toBeInTheDocument();
  });

  it("hides excluded members (e.g. the member being edited)", async () => {
    render(<PatraoPicker onSelect={vi.fn()} excludeIds={[1]} />);

    expect(await screen.findByText("Person 2")).toBeInTheDocument();
    expect(screen.queryByText("Person 1")).not.toBeInTheDocument();
  });

  it("searches on the server after a short debounce", async () => {
    render(<PatraoPicker onSelect={vi.fn()} />);
    await screen.findByText("Person 1");
    svc.getUsers.mockClear();

    await userEvent.type(screen.getByPlaceholderText("Nome, ID ou nmec..."), "ana");

    await waitFor(() =>
      expect(svc.getUsers).toHaveBeenCalledWith({ limit: 50, skip: 0, search: "ana" })
    );
    // typing "a", "an", "ana" quickly must not fire three requests
    expect(svc.getUsers).toHaveBeenCalledTimes(1);
  });

  it("does not offer 'load more' when the first page is not full", async () => {
    render(<PatraoPicker onSelect={vi.fn()} />);
    await screen.findByText("Person 1");

    expect(screen.queryByRole("button", { name: /carregar mais/i })).not.toBeInTheDocument();
  });

  it("loads the next page and appends without duplicating members", async () => {
    svc.getUsers
      .mockResolvedValueOnce(page(1, 50))
      .mockResolvedValueOnce({ items: [person(50), person(51)] }); // 50 repeats on purpose
    render(<PatraoPicker onSelect={vi.fn()} />);
    await screen.findByText("Person 1");

    await userEvent.click(screen.getByRole("button", { name: /carregar mais/i }));

    expect(await screen.findByText("Person 51")).toBeInTheDocument();
    expect(svc.getUsers).toHaveBeenLastCalledWith({ limit: 50, skip: 50 });
    expect(screen.getAllByText("Person 50")).toHaveLength(1);
    expect(screen.queryByRole("button", { name: /carregar mais/i })).not.toBeInTheDocument();
  });

  it("still offers 'load more' when excluding a member from a full page", async () => {
    svc.getUsers.mockResolvedValue(page(1, 50));
    render(<PatraoPicker onSelect={vi.fn()} excludeIds={[1]} />);

    await screen.findByText("Person 2");

    expect(screen.getByRole("button", { name: /carregar mais/i })).toBeInTheDocument();
  });

  it("survives a failing request", async () => {
    svc.getUsers.mockRejectedValue(new Error("down"));
    render(<PatraoPicker onSelect={vi.fn()} />);

    expect(await screen.findByText("Sem Patrão")).toBeInTheDocument();
    await waitFor(() => expect(console.error).toHaveBeenCalled());
  });
});
