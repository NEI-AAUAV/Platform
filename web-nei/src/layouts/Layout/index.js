import React from "react";
import { Outlet, useLocation } from "react-router-dom";

import Navbar from "../Navbar";
import Footer, { MainFooter } from "../Footer";

const CleanLayout = () => (
  <div className="relative flex min-h-screen flex-col justify-between pt-20">
    <Outlet />
  </div>
);

const Layout = () => (
  <div className="flex-column relative flex min-h-screen justify-between pt-20">
    <Navbar />
    <Outlet />
    <Footer />
  </div>
);

const MainLayout = () => {
  const location = useLocation();
  return (
    <div className="relative flex min-h-screen flex-col justify-between pt-20">
      <Navbar />
      <div className="mx-auto w-full max-w-[90rem] px-1 py-8 sm:px-5 md:py-16">
        <Outlet />
      </div>
      {location.pathname === "/" ? <MainFooter /> : <Footer />}
    </div>
  );
};

export { Layout as default, MainLayout, CleanLayout };
