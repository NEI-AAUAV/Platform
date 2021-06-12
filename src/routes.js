import React from "react";
import { Navigate } from "react-router-dom";

import MainLayout from "./Layouts/MainLayout";

import Homepage from "./Pages/Homepage";
import Team from "./Pages/Team";
import Partners from "./Pages/Partners";
import Error404 from "./Pages/Error404";
import SeniorsLEI from "./Pages/SeniorsLEI"
import SeniorsMEI from "./Pages/SeniorsMEI"
import Faina from "./Pages/Faina"
import News from "./Pages/News";
import NewsArticle from "./Pages/NewsArticle";
import RGM from "./Pages/RGM";
import Calendar from "./Pages/Calendar";
import History from "./Pages/History";
import CleanLayout from "./Layouts/CleanLayout";
import Apontamentos from "./Pages/Apontamentos";
import FeedbackForm from './Pages/Forms/FeedbackForm';


const routes = [
	{
		path: "/",
		element: <CleanLayout />,
		children: [
			{ path: "/", element: <Homepage /> },
		]
	},
	{
		path: "/",
		element: <MainLayout />,
		children: [
			{ path: "/noticias", element: <News /> },
			{ path: "/noticia/:id", element: <NewsArticle /> },
			{ path: "/apontamentos", element: <Apontamentos />},
			{ path: "/equipa", element: <Team /> },
			{ path: "/parceiros", element: <Partners /> },
			{ path: "/calendario", element: <Calendar /> },
			{ path: "/rgm/:id", element: <RGM /> },
			{ path: "/historia", element: <History /> },
			{ path: "/seniorsLEI", element: <SeniorsLEI /> },
			{ path: "/seniorsMEI", element: <SeniorsMEI /> },
			{ path: "/faina", element: <Faina/> },
			// Forms
			{ path: "/forms/feedback", element: <FeedbackForm/> },
			// Everything else is 404
			{ path: "/:id", element: <Error404 /> }
		],
	}
];

export default routes;
