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
 *  tags            pills {name: str, color: str, className: str} (Optional)
 *  style (Optional)
 */
const Document = ({name, description, link, blank, className, icon, size, onClick, title, tags, style}) => {
    
    

    return (
        <a 
            href={link && link} 
            target={blank ? "_blank" : "_self"}
            rel={blank ? "noreferrer" : ""}
            className={"d-flex text-left mb-5 p-3 document " + className}
            title="Descarregar ficheiro"
            onClick={onClick}
            title={title ? title : ""}
            style={style}
        >
            <FontAwesomeIcon className="text-primary mr-3" icon={ icon ? icon : faFilePdf } size={size ? size : "3x"}/>
            <div>
                <h4 className="mb-0 text-dark break-all">{name}</h4>
                <p className="small text-secondary mb-0">{description}</p>
                <div className="row mx-0 mt-1">
                    {
                        tags && tags.map(
                            tag =>
                            <span 
                                className={"ml-0 mb-1 mr-1 badge badge-pill " + tag.className}  
                            >{tag.name}</span>
                        )
                    }
                </div>
            </div>
        </a>
    );
}

export default Document;