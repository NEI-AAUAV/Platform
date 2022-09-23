import React from "react";
import './index.css';
import ThemeSwitcher from "components/ThemeSwitcher";

const FloatingBtns = ({location, ...props}) => {
    return (
        <div className={"d-flex flex-column floatingbtns " + location}>
            {props.children}
            <ThemeSwitcher/>
        </div>
    );
}

export default FloatingBtns;