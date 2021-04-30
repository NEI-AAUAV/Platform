import React from "react";
import { Navigate } from "react-router-dom";

import MainLayout from "./Layouts/MainLayout";

import Homepage from "./Pages/Homepage";
import Team from "./Pages/Team";
import Partners from "./Pages/Partners";
import Error404 from "./Pages/Error404";
import RGM from "./Pages/RGM";


const routes = [
	{
		path: "/",
		element: <MainLayout />,
		children: [
            { path: "/", element: <Homepage /> },
            { path: "/equipa", element: <Team /> },
            { path: "/parceiros", element: <Partners /> },
			{ path: "/rgm/:id", element: <RGM /> },
            { path: "/:id", element: <Error404 /> },
		],
	}
];

export default routes;
