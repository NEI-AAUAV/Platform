import React from "react";

import {FontAwesomeIcon} from "@fortawesome/react-fontawesome"
import { faFacebookSquare, faInstagram, faYoutube } from '@fortawesome/free-brands-svg-icons'

const Footer = () => {
    return (
        <div className="d-flex flew-row col-10 mx-auto mt-4 mb-2 text-secondary">
            <div>
                <a href="https://www.facebook.com/nei.aauav" target="_blank" className="mr-3 text-secondary">
                    <FontAwesomeIcon icon={ faFacebookSquare } size="lg"/>
                </a>
                <a href="https://www.instagram.com/nei.aauav/" target="_blank" className="mr-3 text-secondary">
                    <FontAwesomeIcon icon={ faInstagram } size="lg"/>
                </a>
                <a href="https://www.youtube.com/channel/UCfvCzdDn0o-avwBSayqrQog/featured" target="_blank" className="mr-3 text-secondary">
                    <FontAwesomeIcon icon={ faYoutube } size="lg"/>
                </a>
            </div>
            <div className="ml-auto">
                <p>&copy; 2021, NEI</p>
            </div>
        </div>
    );
}

export default Footer;