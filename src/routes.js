import React from "react";
import { Navigate } from "react-router-dom";

import MainLayout from "./Layouts/MainLayout";

import Homepage from "./Pages/Homepage";


const routes = [
	{
		path: "/",
		element: <MainLayout />,
		children: [
            { path: "/", element: <Homepage /> },
		],
	}
];

export default routes;
