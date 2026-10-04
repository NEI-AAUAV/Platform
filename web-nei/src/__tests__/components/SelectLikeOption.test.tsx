import { render, screen, fireEvent } from "@testing-library/react";
import SelectLikeOption from "../../components/SelectLikeOption";

describe("SelectLikeOption", () => {
  it("calls onClick when pressed", () => {
    const onClick = vi.fn();
    render(
      <SelectLikeOption isSelected={false} onClick={onClick}>
        Futsal
      </SelectLikeOption>
    );
    fireEvent.click(screen.getByRole("button", { name: "Futsal" }));
    expect(onClick).toHaveBeenCalledTimes(1);
  });

  it("adds ring styles only when selected", () => {
    const { rerender } = render(
      <SelectLikeOption isSelected={false} onClick={vi.fn()}>
        A
      </SelectLikeOption>
    );
    expect(screen.getByRole("button")).not.toHaveClass("ring-ring");
    rerender(
      <SelectLikeOption isSelected onClick={vi.fn()}>
        A
      </SelectLikeOption>
    );
    expect(screen.getByRole("button")).toHaveClass("ring-ring");
  });
});
