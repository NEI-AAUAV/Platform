import React from "react";
import { Outlet } from 'react-router-dom';
import Particles from "react-tsparticles";

import {
    Col
} from "react-bootstrap";

import Navbar from "../../Components/Navbar";
import Footer from "../../Components/Footer";
import config from "./config";

const MainLayout = () => {

    return (
        <>
            <Particles
                id="tsparticles"
                init={() => console.log("INIT")}
                loaded={() => console.log("LOADED")}
                options={config}
                className="position-absolute"
            />
            <div className="pt-5">
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