import { useEffect, useState, useRef } from "react";
import { Link, useLocation } from "react-router-dom";
import classname from "classname";

import LinkAdapter from "utils/LinkAdapter";
import { useWindowSize, useWindowScroll } from "utils/hooks";
import logo from 'assets/images/logo.png';

import { useUserStore } from "stores/useUserStore";

import {
    ExpandLessIcon,
    ExpandMoreIcon,
    OpenInNewIcon,
    LogoutIcon,
    DarkModeIcon,
    LightModeIcon,
    MenuIcon,
    CloseIcon,
    PersonIcon
} from "assets/icons/google";

import { data, dataCompacted } from "./data";


const Navbar = () => {
    const navRef = useRef(null);
    const navMobileRef = useRef(null);
    const location = useLocation();
    const windowSize = useWindowSize();
    const windowScroll = useWindowScroll();
    const [openMobile, setOpenMobile] = useState(false);
    const { theme, loggedIn } = useUserStore(state => state);
    const [navItems, setNavItems] = useState(data);

    useEffect(() => {
        // Close navbar mobile when location changes
        setOpenMobile(false);
        resetMenuDropdowns();
    }, [location]);

    useEffect(() => {
        // Close navbar mobile when window width is md
        if (openMobile && windowSize.width >= 768) {
            setOpenMobile(false);
            resetMenuDropdowns();
        }
        if (windowSize.width < 1024) {
            setNavItems(dataCompacted(5));
        } else {
            setNavItems(dataCompacted(7));
        }
    }, [windowSize.width]);

    useEffect(() => {
        // Dropdown animation for navbar mobile
        const nav = navMobileRef.current;
        if (openMobile) {
            nav.style.maxHeight = `${nav.scrollHeight + 32}px`;
        } else {
            nav.style.maxHeight = null;
        }
    }, [openMobile])

    function toggleTheme() {
        useUserStore.getState().setTheme(theme === "light" ? "dark" : "light");
    }

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
            <nav
                className={classname("fixed text-sm font-bold top-0 z-40 w-full text-base-300-content transition-size ease-out",
                    openMobile && windowSize.width < 768 ? "!bg-base-200 border border-base-300 !shadow-lg m-1 !w-[calc(100%-0.5rem)] rounded-md" : "border-transparent",
                    windowScroll.y > 0 ? "bg-base-100/80 shadow backdrop-blur" : "bg-transparent")}
            >
                <div ref={navRef} className="h-20 navbar w-full max-w-[90rem] mx-auto">
                    <div className="navbar-start basis-[100px] !w-fit">
                        <Link to="/">
                            <img role="button" src={logo} width="60" height="60" alt="NEI-AAUAv" />
                        </Link>
                    </div>
                    <div className="navbar-center hidden md:flex">
                        <ul className="menu menu-horizontal px-1">
                            {navItems.map(({ name, link, dropdown }, index) => (
                                !dropdown ? (
                                    <li key={index}>
                                        <LinkAdapter to={link}>{name}</LinkAdapter>
                                    </li>
                                ) : (
                                    <li key={index} tabIndex={0} onMouseDown={e => e.preventDefault()}>
                                        <a className="gap-1">
                                            {name}
                                            <ExpandMoreIcon />
                                        </a>
                                        <ul className="p-2 bg-base-200 border border-base-300 shadow !rounded-box w-52">
                                            {dropdown.map(({ name, link, external }, index) =>
                                                <li key={index}>
                                                    <LinkAdapter to={link} external={external} className="justify-between">
                                                        {name}
                                                        {!!external && <OpenInNewIcon />}
                                                    </LinkAdapter>
                                                </li>
                                            )}
                                        </ul>
                                    </li>
                                )
                            ))}
                        </ul>
                    </div>
                    <div className="navbar-end gap-x-3 grow !w-fit">
                        <div className={classname("flex p-1 gap-x-3", { "hidden": openMobile })}>
                            <label className="btn btn-circle btn-ghost btn-sm swap swap-rotate">
                                <input type="checkbox" onChange={toggleTheme} checked={theme === 'dark'} />
                                <DarkModeIcon className="swap-on" />
                                <LightModeIcon className="swap-off" />
                            </label>
                            {!loggedIn ?
                                <>
                                    <Link to="/login" className="btn btn-sm">Log in</Link>
                                    <Link to="/register" className="btn btn-primary btn-sm">Sign up</Link>
                                </>
                                :
                                <div className="dropdown dropdown-end">
                                    <label tabIndex={0} className="btn btn-sm btn-ghost gap-1 !px-0.5 flex-nowrap align-middle">
                                        <div className="avatar mr-1">
                                            <div className="w-7 mask mask-circle">
                                                <img src="https://placeimg.com/192/192/people" />
                                            </div>
                                        </div>
                                        <span>
                                            Jorden Foreest
                                        </span>
                                        <label className="swap swap-rotate ">
                                            <input type="checkbox" />
                                            <ExpandMoreIcon className="swap-on" />
                                            <ExpandLessIcon className="swap-off" />
                                        </label>
                                    </label>
                                    <ul tabIndex={0} className="dropdown-content menu p-2 shadow bg-base-200 border border-base-300 rounded-box w-52">
                                        <li>
                                            <Link to="/perfil"><PersonIcon /> Perfil</Link>
                                        </li>
                                        <li>
                                            <Link to="/" onClick={useUserStore.getState().logout}>
                                                <LogoutIcon /> Log out
                                            </Link>
                                        </li>
                                    </ul>
                                </div>
                            }
                        </div>
                        <label className="navbar-hamburger btn btn-circle btn-ghost btn-sm md:hidden swap swap-rotate p-1">
                            <input type="checkbox" checked={openMobile} onChange={(e) => setOpenMobile(e.target.checked)} />
                            <MenuIcon className="swap-off" />
                            <CloseIcon className="swap-on" />
                        </label>
                    </div>

                </div>
                <div ref={navMobileRef} className="navbar-mobile w-full mx-auto transition-all ease-out overflow-hidden max-h-0 md:hidden">
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
                                                    {!!external && <OpenInNewIcon />}
                                                </LinkAdapter>
                                            </li>
                                        )}
                                    </ul>
                                </li>
                            )
                        ))}
                    </ul>
                </div>
            </nav >
            <div
                className={classname("modal", { "modal-open": openMobile })}
                onClick={() => setOpenMobile(false)}
            />
        </>
    )
}

export default Navbar;