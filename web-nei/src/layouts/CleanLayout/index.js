import React from "react";
import { Outlet } from 'react-router-dom';

import TopButton from "components/TopButton";

import Navbar from "../Navbar";
import Footer from "../Footer";


const CleanLayout = () => {

    return (
        <div className="pt-20 min-h-screen d-flex flex-column justify-content-between">
            <Navbar />
            <Outlet />
            <Footer />
            <TopButton />
        </div>
    );
}

export default CleanLayout;