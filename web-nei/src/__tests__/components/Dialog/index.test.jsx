import { describe, it, expect, vi } from "vitest";
import { render, screen, fireEvent } from "@testing-library/react";
import Dialog, { EventDialog } from "../../../components/Dialog";

vi.mock("../../../utils/hooks", () => ({
  useWindowSize: () => ({ width: 1024, height: 768 }),
}));

vi.mock("../../../assets/icons/google", () => ({
  EventIcon: () => <span data-testid="event-icon">Event</span>,
  CloseIcon: () => <span data-testid="close-icon">Close</span>,
}));

describe("Dialog", () => {
  it("renders children without opening the dialog", () => {
    render(
      <Dialog dialog={<div>content</div>}>
        <button type="button">trigger</button>
      </Dialog>
    );

    expect(screen.getByText("trigger")).toBeInTheDocument();
  });

  it("does not render dialog content until opened", () => {
    render(
      <Dialog dialog={<div>hidden content</div>}>
        <button type="button">trigger</button>
      </Dialog>
    );

    expect(screen.queryByText("hidden content")).not.toBeInTheDocument();
  });

  it("shows dialog content when children are clicked", () => {
    render(
      <Dialog dialog={<div>shown content</div>}>
        <button type="button">trigger</button>
      </Dialog>
    );

    fireEvent.click(screen.getByText("trigger"));

    expect(screen.getByText("shown content")).toBeInTheDocument();
  });

  it("supports controlled visibility via show/onShowChange", () => {
    const onShowChange = vi.fn();
    render(
      <Dialog
        dialog={<div>controlled content</div>}
        show={true}
        onShowChange={onShowChange}
      >
        <button type="button">trigger</button>
      </Dialog>
    );

    expect(screen.getByText("controlled content")).toBeInTheDocument();
  });

  it("propagates visibility state through onShowChange when uncontrolled", () => {
    const onShowChange = vi.fn();
    render(
      <Dialog dialog={<div>content</div>} onShowChange={onShowChange}>
        <button type="button">trigger</button>
      </Dialog>
    );

    expect(onShowChange).toHaveBeenCalledWith(false);
  });
});

describe("EventDialog", () => {
  const baseEvent = {
    title: "Reunião NEI",
    start: new Date(2026, 0, 10),
    end: new Date(2026, 0, 10),
    category: { name: "NEI", color: "131 72% 28%" },
  };

  it("renders nothing when there is no event", () => {
    render(
      <EventDialog event={null} show={true} onShowChange={vi.fn()}>
        <button type="button">trigger</button>
      </EventDialog>
    );

    expect(screen.getByText("trigger")).toBeInTheDocument();
  });

  it("shows the event title and category when open", () => {
    render(
      <EventDialog event={baseEvent} show={true} onShowChange={vi.fn()}>
        <button type="button">trigger</button>
      </EventDialog>
    );

    expect(screen.getByText("Reunião NEI")).toBeInTheDocument();
    expect(screen.getByText("NEI")).toBeInTheDocument();
  });

  it("closes the dialog when the close icon is clicked", () => {
    const onShowChange = vi.fn();
    const { container } = render(
      <EventDialog event={baseEvent} show={true} onShowChange={onShowChange}>
        <button type="button">trigger</button>
      </EventDialog>
    );

    const closeButton = container.querySelector(".btn-circle");
    expect(closeButton).not.toBeNull();

    fireEvent.click(closeButton);

    expect(onShowChange).toHaveBeenCalledWith(false);
  });
});
