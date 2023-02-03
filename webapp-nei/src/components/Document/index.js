import React from "react";
import LinkAdapter from "components/LinkAdapter";

import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
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
 *  iconColor       Icon color                      (Optional, default .text-primary)
 *  size            Icon size                       (Optional, default 3x)
 *  onClick         on click event handler          (Optional)
 *  title           title attribute                 (Optional)
 *  tags            pills {name: str, color: str, className: str} (Optional)
 *  image           A banner                        (Optional)
 *                  NOTE: Make sure all images have the same dimensions, otherwise the cards won't be aligned!
 *  style (Optional)
 */
const Document = ({ name, description, link, blank, className, icon, size, onClick, title, tags, style, image, iconColor }) => {
    return (
        <LinkAdapter
            to={link}
            onClick={onClick}
            title={title ? title : ""}
            style={style}
            className={"m-0 p-0 document-container " + className}
        >
            <div className="document">
                {
                    image &&
                    <img src={image} className="w-100" />
                }
                <div
                    className={"d-flex text-left p-3 "}
                >
                    <FontAwesomeIcon
                        className={iconColor ? "mr-3" : "text-primary mr-3"}
                        icon={icon ? icon : faFilePdf}
                        size={size ? size : "3x"}
                        style={iconColor ? { color: iconColor } : {}}
                    />
                    <div>
                        <h4 className="mb-0 break-all">{name}</h4>
                        <p className="small text-secondary mb-0" dangerouslySetInnerHTML={{ __html: description }}></p>
                        <div className="row mx-0 mt-1">
                            {
                                tags && tags.map((tag, index) =>
                                    <span
                                        key={index}
                                        className={"ml-0 mb-1 mr-1 badge badge-pill " + tag.className}
                                        style={tag.color ? { backgroundColor: tag.color } : {}}
                                    >{tag.name}</span>
                                )
                            }
                        </div>
                    </div>
                </div>
            </div>
        </LinkAdapter>
    );
}

export default Document;
