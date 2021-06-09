import React from "react";
import { Navigate } from "react-router-dom";

import MainLayout from "./Layouts/MainLayout";

import Homepage from "./Pages/Homepage";
import Team from "./Pages/Team";
import Partners from "./Pages/Partners";
import Error404 from "./Pages/Error404";
import SeniorsLEI from "./Pages/SeniorsLEI"
import SeniorsMEI from "./Pages/SeniorsMEI"
import News from "./Pages/News";
import NewsArticle from "./Pages/NewsArticle";
import RGM from "./Pages/RGM";
import Calendar from "./Pages/Calendar";
import History from "./Pages/History";
import Merchandising from "./Pages/Merchandising";
import CleanLayout from "./Layouts/CleanLayout";


const routes = [
	{
		path: "/",
		element: <CleanLayout />,
		children: [
			{ path: "/", element: <Homepage /> },
			{ path: "/merch", element: <Merchandising/> }
		]
	},
	{
		path: "/",
		element: <MainLayout />,
		children: [
			{ path: "/noticias", element: <News /> },
			{ path: "/noticia/:id", element: <NewsArticle /> },
			{ path: "/equipa", element: <Team /> },
			{ path: "/parceiros", element: <Partners /> },
			{ path: "/calendario", element: <Calendar /> },
			{ path: "/rgm/:id", element: <RGM /> },
			{ path: "/historia", element: <History /> },
			{ path: "/seniorsLEI", element: <SeniorsLEI /> },
			{ path: "/seniorsMEI", element: <SeniorsMEI /> },
			{ path: "/:id", element: <Error404 /> }
		],
	}
];

export default routes;
