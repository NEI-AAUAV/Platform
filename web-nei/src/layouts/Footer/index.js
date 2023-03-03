
import React from "react";

import {
    FacebookIcon,
    InstagramIcon,
    LinkedinIcon,
    LinktreeIcon,
    GithubIcon,
    YoutubeIcon
} from "assets/icons/social";



const data = [
    {
        icon: <YoutubeIcon />,
        url: "https://www.youtube.com/@neiaauav2598"
    },
    {
        icon: <GithubIcon />,
        url: "https://github.com/NEI-AAUAV"
    },
    {
        icon: <FacebookIcon />,
        url: "https://www.facebook.com/nei.aauav"
    },
    {
        icon: <InstagramIcon />,
        url: "https://www.instagram.com/nei.aauav/"
    },
    {
        icon: <LinktreeIcon />,
        url: "https://linktr.ee/NEI_AAUAv"
    },
    {
        icon: <LinkedinIcon />,
        url: "https://www.linkedin.com/company/nei-aauav"
    },
]


// className="btn btn-ghost text-accent btn-xs btn-circle mx-1 inline-block"
const Footer = () => {
    return (
        <footer className="footer relative items-center p-4 w-full max-w-[90rem] mx-auto flex justify-center flex-col-reverse xs:justify-between xs:flex-row gap-2">
            <div className="items-center grid-flow-col">
                <p>&copy; {new Date().getFullYear()} - All right reserved by NEI-AAUAv</p>
            </div>
            <div className="grid-flow-col gap-3 md:place-self-center md:justify-self-end">
                {data.map(({ icon, url }, index) => (
                    <a key={index} href={url} target="_blank" className="btn btn-sm btn-circle btn-ghost">
                        {icon}
                    </a>
                ))}
            </div>
        </footer>
    );
}

export default Footer;

