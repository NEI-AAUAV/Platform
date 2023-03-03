import React from "react";
import { Outlet } from 'react-router-dom';

const SimpleLayout = () => {

    return (
        <div className="pt-20 min-h-screen flex flex-col justify-between relative">
            <Outlet />
        </div>
    );
}

export default SimpleLayout;
