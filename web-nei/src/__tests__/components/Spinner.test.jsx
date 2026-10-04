import { render, screen } from "@testing-library/react";
import Spinner from "../../components/Spinner";

describe("Spinner", () => {
  it("renders loading text", () => {
    render(<Spinner />);
    expect(screen.getByText("A carregar...")).toBeInTheDocument();
  });

  it("applies extra className", () => {
    render(<Spinner className="custom-cls" />);
    expect(screen.getByRole("status")).toHaveClass("custom-cls");
  });
});
