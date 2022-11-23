import React from "react";
import { Outlet } from 'react-router-dom';
import Particles from "react-tsparticles";

import Navbar from "../../components/Navbar";
import Footer from "../../components/Footer";
import config from "../backgroundconfig";

import { useTheme } from "stores/useTheme";
import TopButton from "components/TopButton";


const CleanLayout = () => {

    const theme = useTheme(state => state.theme);

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
                <TopButton />
            </div>
        </>
    );
}

export default CleanLayout;