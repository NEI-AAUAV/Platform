import { Outlet } from "react-router-dom";

export default function Layout() {
  return (
    <>
      <h1>Hi this is the layout</h1>
      <Outlet />
    </>
  );
}
