import React from "react";
import { Outlet } from 'react-router-dom';
import Particles from "react-tsparticles";

import {
    Col
} from "react-bootstrap";

import Navbar from "../../Components/Navbar";
import Footer from "../../Components/Footer";
import config from "../backgroundconfig";

const MainLayout = () => {

    return (
        <>
            <Particles
                id="tsparticles"
                options={config}
                className="position-absolute"
            />
            <div className="pt-10 mhvh-100 d-flex flex-column justify-content-between">
                <Navbar />

                <Col
                    xs={11}
                    sm={10}
                    className="mx-auto py-5 px-0 col-xxl-9"
                >
                    <Outlet />
                </Col>

                <Footer />
            </div>
        </>
    );
}

export default MainLayout;