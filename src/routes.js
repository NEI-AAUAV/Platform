import React from "react";
import { Navigate } from "react-router-dom";

import MainLayout from "./Layouts/MainLayout";

import Homepage from "./Pages/Homepage";
import Team from "./Pages/Team";
import Partners from "./Pages/Partners";
import Error404 from "./Pages/Error404";
import SeniorsLEI from "./Pages/SeniorsLEI"

const routes = [
	{
		path: "/",
		element: <MainLayout />,
		children: [
            { path: "/", element: <Homepage /> },
            { path: "/equipa", element: <Team /> },
            { path: "/parceiros", element: <Partners /> },
            { path: "/:id", element: <Error404 /> },
			{ path: "/seniorsLEI", element: <SeniorsLEI/>}
		],
	}
];

export default routes;
