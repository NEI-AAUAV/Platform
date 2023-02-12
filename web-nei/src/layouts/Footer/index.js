
import React from "react";

import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faFacebookSquare, faInstagram, faYoutube } from '@fortawesome/free-brands-svg-icons';
import { SiLinktree } from "react-icons/si";

const Footer = () => {
    return (
        <div id="footer" className="d-flex flew-row col-11 col-sm-10 col-xxl-9 mx-auto text-secondary">
            <div className="footer-links">
                <a href="https://www.facebook.com/nei.aauav" target="_blank" class="btn btn-ghost text-accent btn-xs btn-circle mx-1 inline-block">
                    <FontAwesomeIcon icon={faFacebookSquare} size="lg" />
                </a>
                <a href="https://www.instagram.com/nei.aauav/" target="_blank" class="btn btn-ghost text-accent btn-xs btn-circle mx-1 inline-block">
                    <FontAwesomeIcon icon={faInstagram} size="lg" />
                </a>
                <a href="https://www.youtube.com/channel/UCfvCzdDn0o-avwBSayqrQog/featured" target="_blank" class="btn btn-ghost text-accent btn-xs btn-circle mx-1 inline-block">
                    <FontAwesomeIcon icon={faYoutube} size="lg" />
                </a>
                <a href="https://linktr.ee/NEI_AAUAv" target="_blank" class="btn btn-ghost text-accent btn-xs btn-circle mx-1 inline-block">
                    <SiLinktree size="22px" />
                </a>
            </div>

            <div className="footer-copyright">
                &copy; 2022, NEI-AAUAV
            </div>
        </div>
    );
}

export default Footer;

