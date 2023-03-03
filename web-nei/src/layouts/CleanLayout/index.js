import React from "react";
import { Outlet } from 'react-router-dom';

import Navbar from "../Navbar";
import Footer from "../Footer";


const CleanLayout = () => {

    return (
        <div className="pt-20 min-h-screen d-flex flex-column justify-content-between relative">
            <Navbar />
            <Outlet />
            <Footer />
        </div>
    );
}

export default CleanLayout;