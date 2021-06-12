import React from "react";
import './index.css';

const FloatingBtns = ({location, ...props}) => {
    return (
        <div className={"d-flex flex-column floatingbtns " + location}>
            {props.children}
        </div>
    );
}

export default FloatingBtns;