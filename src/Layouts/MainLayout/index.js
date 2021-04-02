import React from "react";
import { Outlet } from 'react-router-dom';

import {
    Col
} from "react-bootstrap";

import Navbar from "../../Components/Navbar";

const MainLayout = () => {
    return (
        <div>
            <Navbar />

            <Col
                lg={10}
                xs={11}
                className="mx-auto py-5"
            >
                <Outlet />
            </Col>
        </div>
    );
}

export default MainLayout;