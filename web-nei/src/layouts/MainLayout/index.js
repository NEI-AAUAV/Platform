import React from "react";
import { Outlet } from 'react-router-dom';

import {
    Col
} from "react-bootstrap";

import TopButton from "components/TopButton";

import Navbar from "../Navbar";
import Footer from "../Footer";



const MainLayout = () => {

    return (
        <div className="pt-20 min-h-screen d-flex flex-column justify-content-between">
            <Navbar />
            <div className="max-w-[90rem] mx-auto pt-8 md:pt-16 px-1 sm:px-5">
                <Outlet />
            </div>
            <Footer />
            <TopButton />
        </div>
    );
}

export default MainLayout;