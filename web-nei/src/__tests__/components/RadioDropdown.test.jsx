import { render, screen, fireEvent } from "@testing-library/react";
import RadioDropdown from "../../components/RadioDropdown";

const options = [
  { value: "a", label: "Alpha" },
  { value: "b", label: "Beta", color: "var(--s)" },
];

describe("RadioDropdown", () => {
  it("renders trigger and options with checked value", () => {
    render(
      <RadioDropdown name="f" value="b" options={options} onChange={vi.fn()}>
        Filtro
      </RadioDropdown>
    );
    expect(screen.getByText("Filtro")).toBeInTheDocument();
    const radios = screen.getAllByRole("radio");
    expect(radios).toHaveLength(2);
    expect(radios[1]).toBeChecked();
    expect(radios[0]).not.toBeChecked();
  });

  it("calls onChange with option value", () => {
    const onChange = vi.fn();
    render(
      <RadioDropdown name="f" value="b" options={options} onChange={onChange}>
        Filtro
      </RadioDropdown>
    );
    fireEvent.click(screen.getByLabelText("Alpha"));
    expect(onChange).toHaveBeenCalledWith("a");
  });

  it("renders without options", () => {
    render(<RadioDropdown name="f" onChange={vi.fn()}>X</RadioDropdown>);
    expect(screen.queryAllByRole("radio")).toHaveLength(0);
  });
});
