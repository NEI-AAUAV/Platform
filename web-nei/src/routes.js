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
import Components from "./pages/Components";
import { RallyTascas, rallyTascasRoutes } from "pages/RallyTascas";
import Test from "./pages/Test";
import TacauaAdminDemo from "./pages/TacauaAdminDemo";

const routes = [
  {
    path: "/",
    element: <MainLayout />,
    children: [
      { path: "/", element: <Homepage /> },
      { path: "/noticias", element: <News /> },
      { path: "/noticia/:id", element: <NewsArticle /> },
      { path: "/apontamentos", element: <Apontamentos /> },
      { path: "/equipa", element: <Team /> },
      { path: "/parceiros", element: <Partners /> },
      { path: "/calendario", element: <Calendar /> },
      { path: "/rgm/:id", element: <RGM /> },
      { path: "/historia", element: <History /> },
      { path: "/seniors/:id", element: <Seniors /> },
      { path: "/merch", element: <Merchandising /> },
      { path: "/faina", element: <Faina /> },
      { path: "/videos", element: <Videos /> },
      { path: "/videos/:id", element: <Video /> },
      // { path: "/estagios", element: <Internship /> },
      !config.PRODUCTION && { path: "/desporto", element: <Sports /> },
      !config.PRODUCTION && { path: "/components", element: <Components /> },
      // { path: "/forms/feedback", element: <FeedbackForm /> },
      { path: "/:id", element: <Error404 /> },
    ],
  },
  {
    path: "/",
    element: <CleanLayout />,
    children: [
      { path: "/familias", element: <FainaTree /> },
    ],
  },
  // {
  //   path: "/",
  //   element: <SimpleLayout />,
  //   children: [
  //     { path: "/breakthebars", element: <RallyTascas />, children: rallyTascasRoutes },
  //   ],
  // },
<<<<<<< HEAD:frontend/src/routes.js
=======
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
      { path: "/testing", element: <Test />},
      { path: "/tacaua-admin-demo", element: <TacauaAdminDemo />},
      { path: "/:id", element: <Error404 /> },

    ],
  },
>>>>>>> 908d97351459e9dbc272c0fc07ce0402c0c3363c:web-nei/src/routes.js
];

export default routes;
