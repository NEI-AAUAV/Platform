import { render, screen, fireEvent } from "@testing-library/react";
import Tabs from "../../components/Tabs";

const tabs = ["Um", "Dois", "Três"];

describe("Tabs", () => {
  it("renders a tab per item and marks the initial value selected", () => {
    render(<Tabs tabs={tabs} value="Dois" onChange={vi.fn()} />);
    expect(screen.getAllByRole("tab")).toHaveLength(3);
    expect(screen.getByRole("tab", { name: "Dois" })).toHaveAttribute("aria-selected", "true");
    expect(screen.getByRole("tab", { name: "Um" })).toHaveAttribute("aria-selected", "false");
  });

  it("defaults selection to first tab", () => {
    render(<Tabs tabs={tabs} onChange={vi.fn()} />);
    expect(screen.getByRole("tab", { name: "Um" })).toHaveAttribute("aria-selected", "true");
  });

  it("calls onChange on click and on Enter only", () => {
    const onChange = vi.fn();
    render(<Tabs tabs={tabs} value="Um" onChange={onChange} />);
    const tab = screen.getByRole("tab", { name: "Três" });
    fireEvent.click(tab);
    expect(onChange).toHaveBeenLastCalledWith("Três");
    fireEvent.keyDown(tab, { key: "Enter" });
    expect(onChange).toHaveBeenCalledTimes(2);
    fireEvent.keyDown(tab, { key: "a" });
    expect(onChange).toHaveBeenCalledTimes(2);
  });

  it("uses renderTab and focus/hover state", () => {
    render(<Tabs tabs={tabs} value="Um" onChange={vi.fn()} renderTab={(t) => `#${t}`} />);
    const tab = screen.getByRole("tab", { name: "#Dois" });
    fireEvent.focus(tab);
    fireEvent.mouseLeave(screen.getByRole("tablist"));
    fireEvent.mouseEnter(tab);
    expect(tab).toBeInTheDocument();
  });

  it("scroll buttons call scrollBy", () => {
    const scrollBy = vi.fn();
    Element.prototype.scrollBy = scrollBy;
    const { container } = render(<Tabs tabs={tabs} value="Um" onChange={vi.fn()} />);
    const [back] = container.querySelectorAll("button");
    fireEvent.click(back);
    fireEvent.click(container.querySelector("button[name=forward]"));
    expect(scrollBy).toHaveBeenCalledWith(-300, 0);
    expect(scrollBy).toHaveBeenCalledWith(300, 0);
  });

  it("updates scroll position on scroll and resize", () => {
    const { container } = render(<Tabs tabs={tabs} value="Um" onChange={vi.fn()} />);
    const scroller = container.querySelector(".scrollbar-hide");
    Object.defineProperty(scroller, "scrollWidth", { value: 1000, configurable: true });
    Object.defineProperty(scroller, "clientWidth", { value: 500, configurable: true });
    scroller.scrollLeft = 500;
    fireEvent.scroll(scroller);
    expect(container.querySelector("button[name=forward]")).toHaveClass("btn-disabled");
    window.dispatchEvent(new Event("resize"));
  });
});
