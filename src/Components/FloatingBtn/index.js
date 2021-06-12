import React from "react";
import './index.css';

/**
 * Component for a floating btn
 * 
 * location         String          One of: bottomRight, ...
 * content          Component       Btn content
 * onClick          function        On click handler
 * title            String          Element title
 */
const FloatingBtn = ({location, content, onClick, title}) => {
    return (
        <button 
            className={"floatingbtn btn btn-outline-primary rounded-circle " + location}
            title={title}
            onClick={onClick}
        >
            {content}
        </button>
    );
}

export default FloatingBtn;