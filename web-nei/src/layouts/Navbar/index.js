import { useEffect, useState, useRef } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import classNames from "classnames";

import LinkAdapter from "utils/LinkAdapter";
import { useWindowSize, useWindowScroll } from "utils/hooks";
import logo from "assets/images/logo.png";

import service from "services/NEIService";
import { useUserStore } from "stores/useUserStore";

import {
  ExpandLessIcon,
  ExpandMoreIcon,
  OpenInNewIcon,
  LoginIcon,
  LogoutIcon,
  DarkModeIcon,
  LightModeIcon,
  MenuIcon,
  CloseIcon,
  PersonIcon,
  FamilyPersonIcon,
  SettingsIcon,
  PersonAddIcon,
} from "assets/icons/google";

import otherPic from "assets/default_profile/other.svg";

import { data, dataCompacted } from "./data";
import config from "config";

const Navbar = () => {
  const navRef = useRef(null);
  const navMobileRef = useRef(null);
  const location = useLocation();
  const windowSize = useWindowSize();
  const windowScroll = useWindowScroll();
  const [openMobile, setOpenMobile] = useState(false);
  const { theme, token, name, surname, image } = useUserStore((state) => state);
  const [navItems, setNavItems] = useState(data);
  const navigate = useNavigate();

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
      setNavItems(dataCompacted(4));
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
  }, [openMobile]);

  /** Ugly hack to hide menu dropdowns */
  function resetMenuDropdowns() {
    const d = navRef.current.querySelectorAll(".navbar-center>.menu>li>ul");
    d.forEach((e) => {
      e.classList.add("hidden");
    });
    window.setTimeout(() => {
      d.forEach((e) => {
        e.classList.remove("hidden");
      });
    }, 100);
  }

  /** Dropdown animation for navbar mobile items */
  function toggleMobileDropdown(e) {
    const nav = navMobileRef.current;
    const dropdown = e.target.nextSibling;
    if (!dropdown) return;
    if (dropdown.style.maxHeight) {
      dropdown.style.maxHeight = null;
    } else {
      dropdown.style.maxHeight = `${dropdown.scrollHeight + 32}px`;
    }
    nav.style.maxHeight = `${nav.scrollHeight + dropdown.scrollHeight + 32}px`;
  }

  function toggleTheme() {
    useUserStore.getState().setTheme(theme === "light" ? "dark" : "light");
  }

  function logout() {
    service
      .logout()
      .then(() => {
        useUserStore.getState().logout();
        navigate("/");
      })
      .catch((err) => {
        console.error(err);
      });
  }

  return (
    <>
      <nav
        className={classNames(
          "text-base-300-content fixed top-0 z-40 w-full text-sm font-bold transition-size ease-out",
          openMobile && windowSize.width < 768
            ? "m-1 !w-[calc(100%-0.5rem)] rounded-md border border-base-300 !bg-base-200 !shadow-lg"
            : "border-transparent",
          windowScroll.y > 0
            ? "bg-base-100/80 shadow backdrop-blur"
            : "bg-transparent"
        )}
      >
        <div ref={navRef} className="navbar mx-auto h-20 w-full max-w-[90rem]">
          <div className="navbar-start !w-fit basis-[100px]">
            <Link to="/">
              <img
                role="button"
                src={logo}
                width="60"
                height="60"
                alt="NEI-AAUAv"
              />
            </Link>
          </div>
          <div className="navbar-center hidden md:flex">
            <ul className="menu menu-horizontal px-1">
              {navItems.map(
                ({ name, link, disabled, dropdown, reload }, index) =>
                  !dropdown ? (
                    <li
                      key={index}
                      className={classNames({
                        "pointer-events-none opacity-50": disabled,
                      })}
                    >
                      <LinkAdapter to={link} reload={reload}>
                        {name}
                      </LinkAdapter>
                    </li>
                  ) : (
                    <li
                      key={index}
                      tabIndex={0}
                      onMouseDown={(e) => e.preventDefault()}
                    >
                      <a className="gap-1">
                        {name}
                        <ExpandMoreIcon />
                      </a>
                      <ul className="!rounded-box w-52 border border-base-300 bg-base-200 p-2 shadow">
                        {dropdown.map(
                          ({ name, link, disabled, external, reload }, index) => (
                            <li
                              key={index}
                              className={classNames({
                                "pointer-events-none opacity-50": disabled,
                              })}
                            >
                              <LinkAdapter
                                to={link}
                                external={external}
                                reload={reload}
                                className="justify-between"
                              >
                                {name}
                                {!!external && <OpenInNewIcon />}
                              </LinkAdapter>
                            </li>
                          )
                        )}
                      </ul>
                    </li>
                  )
              )}
            </ul>
          </div>
          <div className="navbar-end !w-fit grow gap-x-3">
            <div
              className={classNames("flex gap-x-3 p-1", { hidden: openMobile })}
            >
              <label className="swap btn-ghost swap-rotate btn-sm btn-circle btn">
                <input
                  type="checkbox"
                  onChange={toggleTheme}
                  checked={theme === "dark"}
                />
                <DarkModeIcon className="swap-on" />
                <LightModeIcon className="swap-off" />
              </label>
              {!token ? (
                <>
                  <Link
                    to="/auth/login"
                    className="btn-neutral btn-outline btn-sm btn-circle btn gap-2 md:!w-fit md:!px-3"
                  >
                    <span className="hidden md:block">Entrar</span>
                    <LoginIcon />
                  </Link>
                  <Link
                    to="/auth/register"
                    className="btn-primary btn-sm btn-circle btn gap-2 md:!w-fit md:!px-3"
                  >
                    <span className="hidden md:block">Registar</span>
                    <PersonAddIcon />
                  </Link>
                </>
              ) : (
                <div className="dropdown-end dropdown">
                  <label
                    tabIndex={0}
                    className="btn-outline btn-sm btn flex-nowrap !px-0.5 align-middle md:gap-1"
                  >
                    <div className="avatar md:mr-1">
                      <div className="mask mask-circle w-7">
                        <img src={image || otherPic} alt="Perfil" />
                      </div>
                    </div>
                    <span className="hidden md:block">
                      {name} {surname}
                    </span>
                    <label className="swap-rotate swap ">
                      <input type="checkbox" />
                      <ExpandMoreIcon className="swap-on" />
                      <ExpandLessIcon className="swap-off" />
                    </label>
                  </label>
                  <ul
                    tabIndex={0}
                    className="dropdown-content menu rounded-box w-52 border border-base-300 bg-base-200 p-2 shadow"
                  >
                    <li>
                      <Link to="/settings/profile">
                        <PersonIcon /> Perfil
                      </Link>
                    </li>
                    {!config.PRODUCTION && (
                      <>
                        <li>
                          <Link to="/settings/family">
                            <FamilyPersonIcon /> Família
                          </Link>
                        </li>
                        <li>
                          <Link to="/settings/account">
                            <SettingsIcon /> Conta
                          </Link>
                        </li>
                      </>
                    )}
                    <li onClick={logout}>
                      <a>
                        <LogoutIcon /> Log out
                      </a>
                    </li>
                  </ul>
                </div>
              )}
            </div>
            <label className="navbar-hamburger swap-rotate swap btn-ghost btn-sm btn-circle btn p-1 md:hidden">
              <input
                type="checkbox"
                checked={openMobile}
                onChange={(e) => setOpenMobile(e.target.checked)}
              />
              <MenuIcon className="swap-off" />
              <CloseIcon className="swap-on" />
            </label>
          </div>
        </div>
        <div
          ref={navMobileRef}
          className="navbar-mobile mx-auto max-h-0 w-full overflow-hidden transition-all ease-out md:hidden"
        >
          <ul className="menu menu-vertical p-5 pt-0">
            {data.map(({ name, link, disabled, dropdown }, index) =>
              !dropdown ? (
                <li
                  key={index}
                  className={classNames({
                    "pointer-events-none opacity-50": disabled,
                  })}
                >
                  <LinkAdapter to={link}>{name}</LinkAdapter>
                </li>
              ) : (
                <li key={index} tabIndex={0}>
                  <a className="justify-between" onClick={toggleMobileDropdown}>
                    {name}
                    <ExpandMoreIcon />
                  </a>
                  <ul className="relative left-0 ml-4 flex max-h-0 overflow-hidden !rounded-none border-l-2 border-base-content/50 pl-2 transition-all ease-out">
                    {dropdown.map(
                      ({ name, link, disabled, external }, index) => (
                        <li
                          key={index}
                          className={classNames({
                            "pointer-events-none opacity-50": disabled,
                          })}
                        >
                          <LinkAdapter to={link} external={external}>
                            {name}
                            {!!external && <OpenInNewIcon />}
                          </LinkAdapter>
                        </li>
                      )
                    )}
                  </ul>
                </li>
              )
            )}
          </ul>
        </div>
      </nav>
      <div
        className={classNames("modal", { "modal-open": openMobile })}
        onClick={() => setOpenMobile(false)}
      />
    </>
  );
};

export default Navbar;
