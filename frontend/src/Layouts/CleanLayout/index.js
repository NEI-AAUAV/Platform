import React from "react";
import { Outlet } from 'react-router-dom';
import Particles from "react-tsparticles";

import {
    Col
} from "react-bootstrap";

import Navbar from "../../Components/Navbar";
import Footer from "../../Components/Footer";
import config from "../backgroundconfig";

import { useTheme } from "Stores/useTheme";

const CleanLayout = () => {

    //const theme = useTheme(state => state.theme);
    const theme = localStorage.getItem('theme', useTheme(state => state.theme));
    console.log(theme)

    return (
        <>
            <Particles
                id="tsparticles"
                options={{
                    ...config, "background": {
                        "color": {
                            "value": theme === 'light' ? "#fff" : "#010409"
                        }
                    }
                }}
                className="position-absolute"
            />
            <div className="pt-10 mhvh-100 d-flex flex-column justify-content-between">
                <Navbar />
                <Outlet />
                <Footer />
            </div>
        </>
    );
}

export default CleanLayout;