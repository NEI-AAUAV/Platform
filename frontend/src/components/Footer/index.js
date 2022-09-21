import React from "react";

import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import { faFacebookSquare, faInstagram, faYoutube } from '@fortawesome/free-brands-svg-icons';

import "./index.css";

const Footer = () => {
    return (
        <div id="footer" className="d-flex flew-row col-11 col-sm-10 col-xxl-9 mx-auto text-secondary">
            <div className="footer-links">
                <a href="https://www.facebook.com/nei.aauav" target="_blank" className="text-secondary">
                    <FontAwesomeIcon icon={ faFacebookSquare } size="lg"/>
                </a>
                <a href="https://www.instagram.com/nei.aauav/" target="_blank" className="text-secondary">
                    <FontAwesomeIcon icon={ faInstagram } size="lg"/>
                </a>
                <a href="https://www.youtube.com/channel/UCfvCzdDn0o-avwBSayqrQog/featured" target="_blank" className="text-secondary">
                    <FontAwesomeIcon icon={ faYoutube } size="lg"/>
                </a>
            </div>
            <div className="footer-copyright">
                &copy; 2022, NEI-AAUAV
            </div>
        </div>
    );
}

export default Footer;