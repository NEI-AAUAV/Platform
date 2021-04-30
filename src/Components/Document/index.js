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
 */
const Document = ({name, description, link, blank}) => {
    return (
        <a 
            href={link ? link : "#"} 
            target={blank ? "_blank" : "_self"}
            rel={blank ? "noreferrer" : ""}
            className="col-lg-3 d-flex text-left mb-5 p-3 document" 
            title="Descarregar ficheiro"
        >
            <FontAwesomeIcon className="text-primary mr-3" icon={ faFilePdf } size="3x"/>
            <div>
                <h4 className="mb-0 text-dark">{name}</h4>
                <p className="small text-secondary mb-0">{description}</p>
            </div>
        </a>
    );
}

export default Document;