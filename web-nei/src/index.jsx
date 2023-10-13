import React from "react";
import { createRoot } from "react-dom/client";

import App from "./App";

// import 'bootstrap/dist/css/bootstrap.min.css';
import "./index.css";

import "react-typist/dist/Typist.css";
import "react-material-symbols/dist/rounded.css";

const container = document.getElementById("root");
const root = createRoot(container);
root.render(<App />);
