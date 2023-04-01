import React from "react";

import { Navigate } from "react-router-dom";

import config from "config";

import Layout, { FullLayout, CleanLayout } from "./layouts/Layout";

import LoginSP from "./auth/LoginSP";
import Register from "./auth/Register";
import LoginIdP from "./auth/LoginIdP";
import RedirectIdP from "./auth/RedirectIdP";
import EmailVerify from "./auth/EmailVerify";
import ForgotPassword from "./auth/ForgotPassword";
import ResetPassword from "./auth/ResetPassword";

import Homepage from "./pages/Homepage";
import Team from "./pages/Team";
import Error404 from "./pages/Error404";
import Seniors from "./pages/Seniors";
import Faina from "./pages/Faina";
import News from "./pages/News";
import NewsArticle from "./pages/NewsArticle";
import RGM from "./pages/RGM";
import Calendar from "./pages/Calendar";
import History from "./pages/History";
import Notes from "./pages/Notes";
import FeedbackForm from "./pages/Forms/FeedbackForm";
import Videos from "./pages/Videos";
import Video from "./pages/Video";
import Sports from "./pages/Sports";
import SportModality from "./pages/SportModality";
import Family from "./pages/Family";
import Internship from "./pages/Internship";
import Components from "./pages/Components";
import Test from "./pages/Test";
import TacauaAdminDemo from "./pages/TacauaAdminDemo";
import { RallyTascas, rallyTascasRoutes } from "pages/RallyTascas";

const routes = [
  {
    path: "/",
    element: <Layout />,
    children: [
      { path: "/", element: <Homepage /> },
      { path: "/news", element: <News /> },
      { path: "/news/:id", element: <NewsArticle /> },
      { path: "/notes", element: <Notes /> },
      { path: "/teams", element: <Team /> },
      { path: "/calendar", element: <Calendar /> },
      { path: "/rgm", element: <RGM /> },
      { path: "/history", element: <History /> },
      { path: "/seniors/:course?", element: <Seniors /> },
      { path: "/faina", element: <Faina /> },
      { path: "/videos", element: <Videos /> },
      { path: "/videos/:id", element: <Video /> },
      // { path: "/estagios", element: <Internship /> },
      { path: "/taca-ua", element: <Sports /> },
      { path: "/taca-ua/:id/:view?", element: <SportModality /> },
      !config.PRODUCTION && { path: "/components", element: <Components /> },
      // { path: "/forms/feedback", element: <FeedbackForm /> },
      { path: "/WSTest", element: <Test /> },
      { path: "/WStacaua-admin-demo", element: <TacauaAdminDemo /> },
      { path: "/redirect", element: <RedirectIdP /> },
      { path: "/auth/register", element: <Register /> },
      { path: "/auth/login", element: <LoginSP /> },
      { path: "/auth/idp", element: <LoginIdP /> },
      { path: "/auth/verify", element: <EmailVerify /> },
      { path: "/auth/forgot", element: <ForgotPassword /> },
      { path: "/auth/reset", element: <ResetPassword /> },
      { path: "/*", element: <Error404 /> },
    ],
  },
  {
    path: "/",
    element: <FullLayout />,
    children: [{ path: "/family", element: <Family /> }],
  },
  // {
  //   path: "/",
  //   element: <CleanLayout />,
  //   children: [
  //     { path: "/breakthebars", element: <RallyTascas />, children: rallyTascasRoutes },
  //   ],
  // },
];

export default routes;
