import React from "react";
import ReactDOM from "react-dom/client";
import Router from "./router";
import { refreshToken } from "@/services/client";
import "./index.css";

// Attempt to load the user session, if any
refreshToken();

ReactDOM.createRoot(document.getElementById("root") as HTMLElement).render(
  <React.StrictMode>
    <Router />
  </React.StrictMode>,
);
