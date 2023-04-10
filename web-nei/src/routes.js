import React from "react";

import config from "config";

import Layout, { FullLayout, CleanLayout } from "./layouts/Layout";

import Login from "./auth/Login";
import Register from "./auth/Register";
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
import Test from "./pages/WSTest";
import TacauaAdminDemo from "./pages/TacauaAdminDemo";
import { RallyTascas, rallyTascasRoutes } from "pages/RallyTascas";

const routes = [
  {
    path: "/",
    element: <Layout />,
    children: [
      { path: "/", element: <Homepage /> },
      { path: "/notes", element: <Notes /> },
      { path: "/calendar", element: <Calendar /> },
      { path: "/videos", element: <Videos /> },
      { path: "/videos/:id", element: <Video /> },
      { path: "/teams", element: <Team /> },
      { path: "/rgm", element: <RGM /> },
      !config.PRODUCTION && { path: "/history", element: <History /> },
      !config.PRODUCTION && { path: "/seniors/:course?", element: <Seniors /> },
      { path: "/faina", element: <Faina /> },
      !config.PRODUCTION && { path: "/taca-ua", element: <Sports /> },
      !config.PRODUCTION && { path: "/taca-ua/:id/:view?", element: <SportModality /> },
      !config.PRODUCTION && { path: "/components", element: <Components /> },
      !config.PRODUCTION && { path: "/WSTest", element: <Test /> },
      !config.PRODUCTION && { path: "/WStacaua-admin-demo", element: <TacauaAdminDemo /> },
      { path: "/redirect", element: <Login onRedirect /> },
      { path: "/auth/register", element: <Register /> },
      { path: "/auth/login", element: <Login /> },
      { path: "/auth/verify", element: <EmailVerify /> },
      { path: "/auth/forgot", element: <ForgotPassword /> },
      { path: "/auth/reset", element: <ResetPassword /> },
      { path: "/*", element: <Error404 /> },
      // { path: "/estagios", element: <Internship /> },
      // { path: "/forms/feedback", element: <FeedbackForm /> },
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
