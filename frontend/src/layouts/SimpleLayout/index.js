import React from "react";
import { Outlet } from 'react-router-dom';

const SimpleLayout = () => {

    return (
        <div className="mhvh-100 d-flex flex-column justify-content-between position-relative">
            <Outlet />
        </div>
    );
}

export default SimpleLayout;
