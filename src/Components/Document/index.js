import React from "react";

import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import { faFilePdf } from '@fortawesome/free-solid-svg-icons';

import "./index.css";

/**
 * Component for document
 * 
 * Arguments
 *  name            File name
 *  description     File description
 *  link            Link for file (without base URL)
 *  blank           Open link in new tab?
 *  className       Extra classes                   (Optional)
 *  icon            Icon component                  (Optional, default PDF)
 *  size            Icon size                       (Optional, default 3x)
 *  onClick         on click event handler          (Optional)
 *  title           title attribute                 (Optional)
 */
const Document = ({name, description, link, blank, className, icon, size, onClick, title}) => {
    return (
        <a 
            href={link && link} 
            target={blank ? "_blank" : "_self"}
            rel={blank ? "noreferrer" : ""}
            className={"d-flex text-left mb-5 p-3 document " + className}
            title="Descarregar ficheiro"
            onClick={onClick}
            title={title ? title : ""}
        >
            <FontAwesomeIcon className="text-primary mr-3" icon={ icon ? icon : faFilePdf } size={size ? size : "3x"}/>
            <div>
                <h4 className="mb-0 text-dark">{name}</h4>
                <p className="small text-secondary mb-0">{description}</p>
            </div>
        </a>
    );
}

export default Document;