import React from "react";
import { Outlet } from 'react-router-dom';

import {
    Col
} from "react-bootstrap";

import Navbar from "../../Components/Navbar";

const MainLayout = () => {
    return (
        <div className="pt-5 bg-danger">
            <Navbar />

            <Col
                lg={10}
                xs={11}
                className="mt-5 mx-auto py-5"
            >
                <Outlet />
            </Col>
        </div>
    );
}

export default MainLayout;