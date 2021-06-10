import React from "react";
import ReactDOM from "react-dom";

import { BrowserRouter } from 'react-router-dom';
import { TerminalContextProvider } from "react-terminal";

import App from "./App";

import 'bootstrap/dist/css/bootstrap.min.css';
import './index.css';

ReactDOM.render((
    <BrowserRouter>
        <TerminalContextProvider>
            <App />
        </TerminalContextProvider>
    </BrowserRouter>
), document.getElementById('root'));