import { useEffect, useState, useRef } from "react";
import { Link, useLocation } from "react-router-dom";
import classname from "classname";

import LinkAdapter from "utils/LinkAdapter";
import { useWindowSize, useWindowScroll } from "utils/hooks";
import logo from 'assets/images/logo.png';

import data from "./data";
import './index.css';


const Navbar = () => {
    const navRef = useRef(null);
    const navMobileRef = useRef(null);
    const location = useLocation();
    const windowSize = useWindowSize();
    const windowScroll = useWindowScroll();
    const [openMobile, setOpenMobile] = useState(false);

    useEffect(() => {
        // Close navbar mobile when location changes
        setOpenMobile(false);
        resetMenuDropdowns();
    }, [location]);

    useEffect(() => {
        // Dropdown animation for navbar mobile
        const nav = navMobileRef.current;
        if (openMobile) {
            nav.style.maxHeight = `${nav.scrollHeight + 32}px`;
        } else {
            nav.style.maxHeight = null;
        }
    }, [openMobile])

    /** Ugly hack to hide menu dropdowns */
    function resetMenuDropdowns() {
        const d = navRef.current.querySelectorAll('.navbar-center>.menu>li>ul');
        d.forEach((e) => { e.classList.add('hidden'); });
        window.setTimeout(() => {
            d.forEach((e) => { e.classList.remove('hidden'); });
        }, 100);
    }

    /** Dropdown animation for navbar mobile items */
    function toggleMobileDropdown(e) {
        const nav = navMobileRef.current;
        const dropdown = e.target.nextSibling;
        if (dropdown.style.maxHeight) {
            dropdown.style.maxHeight = null;
        } else {
            dropdown.style.maxHeight = `${dropdown.scrollHeight + 32}px`;
        }
        nav.style.maxHeight = `${nav.scrollHeight + dropdown.scrollHeight + 32}px`;
    }

    return (
        <>
            <div
                className={classname("fixed top-0 z-40 w-full flex-wrap md:flex-nowrap text-base-300-content transition-colors transition-size ease-out",
                    openMobile && windowSize.width < 768 ? "!bg-base-200 border border-base-300 !shadow-lg m-1 !w-[calc(100%-0.5rem)] rounded-md" : "border-transparent",
                    windowScroll.y > 0 ? "bg-base-100/90 shadow backdrop-blur" : "bg-transparent")}
            >
                <div ref={navRef} className="navbar">
                    <div className="navbar-start">
                        <Link to="/">
                            <img role="button" src={logo} width="60" height="60" alt="NEI" />
                        </Link>
                    </div>
                    <div className="navbar-center hidden md:flex">
                        <ul className="menu menu-horizontal px-1">
                            {data.map(({ name, link, dropdown }, index) => (
                                !dropdown ? (
                                    <li key={index}>
                                        <LinkAdapter to={link}>{name}</LinkAdapter>
                                    </li>
                                ) : (
                                    <li key={index} tabIndex={0}>
                                        <a>
                                            {name}
                                            <svg className="fill-current pointer-events-none" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"><path d="M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z" /></svg>
                                        </a>
                                        <ul className="p-2 bg-base-200 border border-base-300">
                                            {dropdown.map(({ name, link, external }, index) =>
                                                <li key={index}>
                                                    <LinkAdapter to={link} external={external}>
                                                        {name}
                                                        {!!external &&
                                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 -256 1850 1850" version="1.1" width="15" height="15">
                                                                <g transform="matrix(1,0,0,-1,30.372881,1426.9492)">
                                                                    <path fill="currentColor" d="M 1408,608 V 288 Q 1408,169 1323.5,84.5 1239,0 1120,0 H 288 Q 169,0 84.5,84.5 0,169 0,288 v 832 Q 0,1239 84.5,1323.5 169,1408 288,1408 h 704 q 14,0 23,-9 9,-9 9,-23 v -64 q 0,-14 -9,-23 -9,-9 -23,-9 H 288 q -66,0 -113,-47 -47,-47 -47,-113 V 288 q 0,-66 47,-113 47,-47 113,-47 h 832 q 66,0 113,47 47,47 47,113 v 320 q 0,14 9,23 9,9 23,9 h 64 q 14,0 23,-9 9,-9 9,-23 z m 384,864 V 960 q 0,-26 -19,-45 -19,-19 -45,-19 -26,0 -45,19 L 1507,1091 855,439 q -10,-10 -23,-10 -13,0 -23,10 L 695,553 q -10,10 -10,23 0,13 10,23 l 652,652 -176,176 q -19,19 -19,45 0,26 19,45 19,19 45,19 h 512 q 26,0 45,-19 19,-19 19,-45 z" />
                                                                </g>
                                                            </svg>
                                                        }
                                                    </LinkAdapter>
                                                </li>
                                            )}
                                        </ul>
                                    </li>
                                )
                            ))}
                        </ul>
                    </div>
                    <div className="navbar-end gap-x-3">
                        {true ?
                            <>
                                <Link to="/login" className="btn btn-sm">Log in</Link>
                                <Link to="/register" className="btn btn-primary btn-sm">Sign up</Link>
                            </>
                            :
                            <div class="avatar">
                                <div class="w-8 mask mask-squircle">
                                    <img src="https://placeimg.com/192/192/people" />
                                </div>
                            </div>
                        }
                        <label className="navbar-hamburger btn btn-circle btn-ghost md:hidden swap swap-rotate min-h-fit w-fit h-fit p-1">
                            <input type="checkbox" checked={openMobile} onChange={(e) => setOpenMobile(e.target.checked)} />
                            <svg className="swap-off fill-current" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 512 512"><path d="M64,384H448V341.33H64Zm0-106.67H448V234.67H64ZM64,128v42.67H448V128Z" /></svg>
                            <svg className="swap-on fill-current" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 512 512"><polygon points="400 145.49 366.51 112 256 222.51 145.49 112 112 145.49 222.51 256 112 366.51 145.49 400 256 289.49 366.51 400 400 366.51 289.49 256 400 145.49" /></svg>
                        </label>
                    </div>

                </div>
                <div ref={navMobileRef} className="navbar-mobile transition-all ease-out overflow-hidden max-h-0 md:hidden">
                    <ul className="menu menu-vertical p-5 pt-0">
                        {data.map(({ name, link, dropdown }, index) => (
                            !dropdown ? (
                                <li key={index}>
                                    <LinkAdapter to={link}>{name}</LinkAdapter>
                                </li>
                            ) : (
                                <li key={index} tabIndex={0}>
                                    <a className="justify-between" onClick={toggleMobileDropdown}>
                                        {name}
                                        <svg className="fill-current pointer-events-none" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"><path d="M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z" /></svg>
                                    </a>
                                    <ul className="relative left-0 flex transition-all ease-out border-l-2 pl-2 ml-4 !rounded-none border-base-300 overflow-hidden max-h-0">
                                        {dropdown.map(({ name, link, external }, index) =>
                                            <li key={index}>
                                                <LinkAdapter to={link} external={external}>
                                                    {name}
                                                    {!!external &&
                                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 -256 1850 1850" version="1.1" width="15" height="15">
                                                            <g transform="matrix(1,0,0,-1,30.372881,1426.9492)">
                                                                <path fill="currentColor" d="M 1408,608 V 288 Q 1408,169 1323.5,84.5 1239,0 1120,0 H 288 Q 169,0 84.5,84.5 0,169 0,288 v 832 Q 0,1239 84.5,1323.5 169,1408 288,1408 h 704 q 14,0 23,-9 9,-9 9,-23 v -64 q 0,-14 -9,-23 -9,-9 -23,-9 H 288 q -66,0 -113,-47 -47,-47 -47,-113 V 288 q 0,-66 47,-113 47,-47 113,-47 h 832 q 66,0 113,47 47,47 47,113 v 320 q 0,14 9,23 9,9 23,9 h 64 q 14,0 23,-9 9,-9 9,-23 z m 384,864 V 960 q 0,-26 -19,-45 -19,-19 -45,-19 -26,0 -45,19 L 1507,1091 855,439 q -10,-10 -23,-10 -13,0 -23,10 L 695,553 q -10,10 -10,23 0,13 10,23 l 652,652 -176,176 q -19,19 -19,45 0,26 19,45 19,19 45,19 h 512 q 26,0 45,-19 19,-19 19,-45 z" />
                                                            </g>
                                                        </svg>
                                                    }
                                                </LinkAdapter>
                                            </li>
                                        )}
                                    </ul>
                                </li>
                            )
                        ))}
                    </ul>
                </div>
            </div>
            <div
                className={classname("fixed inset-0 z-30 bg-base-100/90", { "hidden": !openMobile })}
                onClick={() => setOpenMobile(false)}
            />
        </>
    )
}

export default Navbar;