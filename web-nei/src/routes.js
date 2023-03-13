import React from "react";

import { Navigate } from "react-router-dom";

import config from "config";

import Layout, { MainLayout, CleanLayout } from "./layouts/Layout";

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
import FainaTree from "./pages/FainaTree";
import Internship from "./pages/Internship";
import Components from "./pages/Components";
import { RallyTascas, rallyTascasRoutes } from "pages/RallyTascas";
import Test from "./pages/Test";
import TacauaAdminDemo from "./pages/TacauaAdminDemo";
import Login from "./pages/Login";
import Register from "./pages/Register";
import EmailVerify from "./pages/EmailVerify";

const routes = [
  {
    path: "/",
    element: <MainLayout />,
    children: [
      { path: "/", element: <Homepage /> },
      { path: "/news", element: <News /> },
      { path: "/news/:id", element: <NewsArticle /> },
      { path: "/notes", element: <Notes /> },
      { path: "/teams", element: <Team /> },
      { path: "/calendar", element: <Calendar /> },
      { path: "/rgm/:category?", element: <RGM /> },
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
      { path: "/testing", element: <Test /> },
      { path: "/tacaua-admin-demo", element: <TacauaAdminDemo /> },
      { path: "/login", element: <Login /> },
      { path: "/register", element: <Register /> },
      { path: "/auth/verify", element: <EmailVerify /> },
      { path: "/*", element: <Error404 /> },
    ],
  },
  {
    path: "/",
    element: <Layout />,
    children: [{ path: "/family", element: <FainaTree /> }],
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
