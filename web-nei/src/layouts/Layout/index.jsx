import React from "react";
import { Outlet, useLocation } from "react-router-dom";

import Navbar from "../Navbar";
import Footer, { MainFooter } from "../Footer";

/** A clean layout without navbar and a footer. */
const CleanLayout = () => (
  <div className="relative flex min-h-screen flex-col justify-between pt-20">
    <Outlet />
  </div>
);

/** A layout that expands to the full available width. */
const FullLayout = () => (
  <div className="relative flex min-h-screen flex-col justify-between pt-20">
    <Navbar />
    <Outlet />
    <Footer />
  </div>
);

const Layout = () => {
  const location = useLocation();
  return (
    <div className="relative flex min-h-screen flex-col justify-between pt-20">
      <Navbar />
      <div className="mx-auto flex w-full max-w-[90rem] grow flex-col px-1 py-8 sm:px-5 md:py-16">
        <Outlet />
      </div>
      {location.pathname === "/" ? <MainFooter /> : <Footer />}
    </div>
  );
};

export { Layout as default, FullLayout, CleanLayout };
