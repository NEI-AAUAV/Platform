import React from "react";
import ReactDOM from "react-dom";

import { BrowserRouter } from 'react-router-dom';

import App from "./App";

import 'bootstrap/dist/css/bootstrap.min.css';
import './index.css';

import "react-typist/dist/Typist.css";

ReactDOM.render((
    <BrowserRouter>
        <App />
    </BrowserRouter>
), document.getElementById('root'));