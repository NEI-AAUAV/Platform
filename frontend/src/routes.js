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
import FainaTree from "./pages/FainaTree";
import Internship from "./pages/Internship";
import { RallyTascas, rallyTascasRoutes } from "pages/RallyTascas";

const routes = [
  {
    path: "/",
    element: <CleanLayout />,
    children: [
      { path: "/", element: <Homepage /> },
      { path: "/merch", element: <Merchandising /> },
      { path: "/familias", element: <FainaTree /> },
    ],
  },
  {
    path: "/",
    element: <SimpleLayout />,
    children: [
      { path: "/breakthebars", element: <RallyTascas />, children: rallyTascasRoutes },
    ],
  },
  {
    path: "/",
    element: <MainLayout />,
    children: [
      { path: "/noticias", element: <News /> },
      { path: "/noticia/:id", element: <NewsArticle /> },
      { path: "/apontamentos", element: <Apontamentos /> },
      { path: "/equipa", element: <Team /> },
      { path: "/parceiros", element: <Partners /> },
      { path: "/calendario", element: <Calendar /> },
      { path: "/rgm/:id", element: <RGM /> },
      { path: "/historia", element: <History /> },
      { path: "/seniors/:id", element: <Seniors /> },
      { path: "/faina", element: <Faina /> },
      { path: "/videos", element: <Videos /> },
      { path: "/videos/:id", element: <Video /> },
      // { path: "/estagios", element: <Internship /> },
      !config.PRODUCTION && { path: "/desporto", element: <Sports /> },
      // { path: "/forms/feedback", element: <FeedbackForm /> },
      { path: "/:id", element: <Error404 /> },
    ],
  },
];

export default routes;
