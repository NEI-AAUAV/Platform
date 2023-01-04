import React from "react";
import { Outlet } from 'react-router-dom';

import TopButton from "components/TopButton";

import Navbar from "../Navbar";
import Footer from "../../components/Footer";


const CleanLayout = () => {

    return (
        <div className="pt-20 d-flex flex-column justify-content-between">
            <Navbar />
            <Outlet />
            <Footer />
            <TopButton />
        </div>
    );
}

export default CleanLayout;