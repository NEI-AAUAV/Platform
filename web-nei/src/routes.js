import React from "react";

import config from "config";

import MainLayout from "./layouts/MainLayout";
import CleanLayout from "./layouts/CleanLayout";
import SimpleLayout from "./layouts/SimpleLayout";

import Homepage from "./pages/Homepage";
import Team from "./pages/Team";
import Partners from "./pages/Partners";
import Error404 from "./pages/Error404";
import Seniors from "./pages/Seniors";
import Faina from "./pages/Faina";
import News from "./pages/News";
import NewsArticle from "./pages/NewsArticle";
import RGM from "./pages/RGM";
import Calendar from "./pages/Calendar";
import History from "./pages/History";
import Merchandising from "./pages/Merchandising";
import Apontamentos from "./pages/Apontamentos";
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

const routes = [
  {
    path: "/",
    element: <MainLayout />,
    children: [
      { path: "/", element: <Homepage /> },
      { path: "/news", element: <News /> },
      { path: "/news/:id", element: <NewsArticle /> },
      { path: "/notes", element: <Apontamentos /> },
      { path: "/teams", element: <Team /> },
      { path: "/parceiros", element: <Partners /> },
      { path: "/calendar", element: <Calendar /> },
      { path: "/rgm/:id", element: <RGM /> },
      { path: "/history", element: <History /> },
      { path: "/seniors/:id", element: <Seniors /> },
      { path: "/merch", element: <Merchandising /> },
      { path: "/faina", element: <Faina /> },
      { path: "/videos", element: <Videos /> },
      { path: "/videos/:id", element: <Video /> },
      // { path: "/estagios", element: <Internship /> },
      { path: "/taca-ua", element: <Sports /> },
      { path: "/taca-ua/:id", element: <SportModality /> },
      !config.PRODUCTION && { path: "/components", element: <Components /> },
      // { path: "/forms/feedback", element: <FeedbackForm /> },
      { path: "/testing", element: <Test />},
      { path: "/tacaua-admin-demo", element: <TacauaAdminDemo />},
      { path: "/:id", element: <Error404 /> },
      { path: "/login", element: <Login /> },
      { path: "/register", element: <Register /> },
    ],
  },
  {
    path: "/",
    element: <CleanLayout />,
    children: [
      { path: "/family", element: <FainaTree /> },
    ],
  },
  // {
  //   path: "/",
  //   element: <SimpleLayout />,
  //   children: [
  //     { path: "/breakthebars", element: <RallyTascas />, children: rallyTascasRoutes },
  //   ],
  // },
];

export default routes;
