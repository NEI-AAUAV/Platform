import React from "react";
import { Outlet } from 'react-router-dom';

import {
    Col
} from "react-bootstrap";

import TopButton from "components/TopButton";

import Navbar from "../Navbar";
import Footer from "../../components/Footer";



const MainLayout = () => {

    return (
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
            <TopButton />
        </div>
    );
}

export default MainLayout;