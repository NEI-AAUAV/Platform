import React from "react";

import MainLayout from "./Layouts/MainLayout";

import Homepage from "./Pages/Homepage";
import Team from "./Pages/Team";
import Partners from "./Pages/Partners";
import Error404 from "./Pages/Error404";
import Seniors from "./Pages/Seniors";
import Faina from "./Pages/Faina"
import News from "./Pages/News";
import NewsArticle from "./Pages/NewsArticle";
import RGM from "./Pages/RGM";
import Calendar from "./Pages/Calendar";
import History from "./Pages/History";
import Merchandising from "./Pages/Merchandising";
import CleanLayout from "./Layouts/CleanLayout";
import Apontamentos from "./Pages/Apontamentos";
import FeedbackForm from './Pages/Forms/FeedbackForm';
import Videos from "./Pages/Videos";
import Video from "./Pages/Video";
import Sports from "./Pages/Sports";
import FainaTree from "./Pages/FainaTree";
import Internship from "./Pages/Internship";


const routes = [
	{
		path: "/",
		element: <CleanLayout />,
		children: [
			{ path: "/", element: <Homepage /> },
			{ path: "/merch", element: <Merchandising /> },
			{ path: "/familias", element: <FainaTree /> },
		]
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
			{ path: "/faina", element: <Faina/> },
			{ path: "/videos", element: <Videos/> },
			{ path: "/videos/:id", element: <Video/> },
			{ path: "/estagios", element: <Internship /> },
			{ path: "/desporto", element: <Sports/>},
			{ path: "/faina", element: <Faina /> },
			{ path: "/videos", element: <Videos /> },
			{ path: "/videos/:id", element: <Video /> },
			// Forms
			{ path: "/forms/feedback", element: <FeedbackForm /> },
			// Everything else is 404
			{ path: "/:id", element: <Error404 /> },
		],
	}
];

export default routes;
