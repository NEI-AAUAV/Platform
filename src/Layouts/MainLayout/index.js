import React from "react";
import { Outlet } from 'react-router-dom';

import {
    Col
} from "react-bootstrap";

import Navbar from "../../Components/Navbar";
import Footer from "../../Components/Footer";

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

            <Footer />
        </div>
    );
}

export default MainLayout;