import { Outlet } from "react-router-dom";

export default function Layout() {
  return (
    <>
      <h1 className="text-3xl sticky top-0">Hi this is the layout</h1>
      <Outlet />
    </>
  );
}
