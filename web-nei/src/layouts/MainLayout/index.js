import React from "react";
import { Outlet } from 'react-router-dom';

import Navbar from "../Navbar";
import Footer from "../Footer";



const MainLayout = () => {

    return (
        <div className="pt-20 min-h-screen flex flex-col justify-between relative">
            <Navbar />
            <div className="w-full max-w-[90rem] mx-auto pt-8 md:pt-16 px-1 sm:px-5">
                <Outlet />
            </div>
            <Footer />
        </div>
    );
}

export default MainLayout;