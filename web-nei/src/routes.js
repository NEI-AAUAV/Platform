import React from "react";
import { Navigate } from "react-router-dom";

import config from "config";

import Layout, { FullLayout, CleanLayout } from "./layouts/Layout";

import {
  Login,
  Register,
  EmailVerify,
  ForgotPassword,
  ResetPassword,
} from "./pages/auth";
import {
  SettingsProfile,
  SettingsFamily,
  SettingsAccount,
} from "./pages/settings";
import NewsList from "pages/News/NewsList";
import Homepage from "./pages/Homepage";
import Team from "./pages/Team";
import Error404 from "./pages/Error404";
import Seniors from "./pages/Seniors";
import Faina from "./pages/Faina";
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

const isProd = config.PRODUCTION;

const routes = ({ isAuth }) => [
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
      !isProd && { path: "/news/:id?", element: <NewsList /> },
      !isProd && { path: "/history", element: <History /> },
      !isProd && { path: "/seniors/:course?", element: <Seniors /> },
      { path: "/faina", element: <Faina /> },
      !isProd && { path: "/taca-ua", element: <Sports /> },
      !isProd && { path: "/taca-ua/:id/:view?", element: <SportModality /> },
      !isProd && { path: "/components", element: <Components /> },
      !isProd && { path: "/WSTest", element: <Test /> },
      !isProd && { path: "/WStacaua-admin-demo", element: <TacauaAdminDemo /> },
      { path: "/auth/verify", element: <EmailVerify /> },
      { path: "/auth/reset", element: <ResetPassword /> },
      { path: "/*", element: <Error404 /> },
      // These must be here and not behind the auth checks, because if they aren't
      // the router would automatically redirect to the homepage after login, and
      // the redirection logic wouldn't work.
      { path: "/auth/login", element: <Login /> },
      { path: "/auth/register", element: <Register /> },
      // { path: "/estagios", element: <Internship /> },
      // { path: "/forms/feedback", element: <FeedbackForm /> },
    ],
  },
  {
    path: "/",
    element: isAuth ? <Layout /> : <Navigate to="/" />,
    children: [
      { path: "/settings/profile", element: <SettingsProfile /> },
      !isProd && { path: "/settings/family", element: <SettingsFamily /> },
      !isProd && { path: "/settings/account", element: <SettingsAccount /> },
    ],
  },
  {
    path: "/",
    element: !isAuth ? <Layout /> : <Navigate to="/" />,
    children: [
      { path: "/auth/register", element: <Register /> },
      { path: "/auth/login", element: <Login /> },
      { path: "/auth/forgot", element: <ForgotPassword /> },
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
