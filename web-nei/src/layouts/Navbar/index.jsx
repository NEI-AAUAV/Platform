import { useEffect, useState, useRef } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import classNames from "classnames";

import LinkAdapter from "utils/LinkAdapter";
import { useWindowSize, useWindowScroll } from "utils/hooks";
import logo from "assets/images/logo.png";
import { GalaLogo } from "assets/icons/extensions";

import service from "services/NEIService";
import { getArraialSocket, destroyArraialSocket } from "services/SocketService";
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
  const { theme, token, name, surname, image, scopes } = useUserStore((state) => state);
  const [navItems, setNavItems] = useState(data);
  const [extNav, setExtNav] = useState([]);
  const navigate = useNavigate();

  // Optimistic hide until known from API/WS
  const [arraialEnabled, setArraialEnabled] = useState(null);
  

  useEffect(() => {
    // Fetch runtime Arraial config and subscribe to WS updates
    service
      .getArraialConfig()
      .then((cfg) => setArraialEnabled(!!cfg?.enabled))
      .catch(() => {
        // Leave as null on error; WS may still update it shortly
      });

    const socket = getArraialSocket();
    const onMessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        if (data?.topic === "ARRAIAL_CONFIG" && typeof data.enabled === "boolean") {
          setArraialEnabled(!!data.enabled);
        }
      } catch (_) {}
    };
    socket.addEventListener("message", onMessage);
    return () => {
      socket.removeEventListener("message", onMessage);
    };
  }, []);

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
      setNavItems(dataCompacted(5));
    }
  }, [windowSize.width]);

  // Load extension nav from manifest endpoint
  useEffect(() => {
    const normalizeLink = (href) => {
      if (!href || typeof href !== "string") return href;
      try {
        // Convert absolute URLs to pathnames for comparison
        if (href.startsWith("http://") || href.startsWith("https://")) {
          return new URL(href, window.location.origin).pathname || "/";
        }
      } catch (_) {}
      return href;
    };
    
    const loadExtensionNav = async () => {
      try {
        // Add timeout to the main extensions manifest call
        const payload = await Promise.race([
          service.getExtensionsManifest(),
          new Promise((_, reject) => 
            setTimeout(() => reject(new Error('Extensions manifest timeout')), 5000)
          )
        ]);
        const items = Array.isArray(payload?.nav) ? payload.nav : [];
        const myScopes = Array.isArray(scopes) ? scopes : [];
        const reqOk = (e) => {
          const req = Array.isArray(e?.requiresScopes) ? e.requiresScopes : [];
          return req.length === 0 || req.some((s) => myScopes.includes(s));
        };
        // Avoid duplicates with existing static nav items
        const existingLinks = new Set(
          (Array.isArray(navItems) ? navItems : [])
            .flatMap((i) => (i?.dropdown ? i.dropdown : [i]))
            .map((i) => normalizeLink(i?.link))
            .filter(Boolean)
        );
        
        const filtered = items
          .filter(reqOk)
          .map((e) => ({ label: e.label, href: e.href, key: normalizeLink(e.href), dynamicVisibility: e.dynamicVisibility }))
          .filter((e) => !existingLinks.has(e.key));
        
        // Check dynamic visibility for items that have it
        const checkDynamicVisibility = async (item) => {
          if (!item.dynamicVisibility) return item;
          
          try {
            // Create AbortController for timeout
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), 3000); // 3 second timeout
            
            const response = await fetch(item.dynamicVisibility.endpoint, {
              signal: controller.signal,
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
              }
            });
            
            clearTimeout(timeoutId);
            
            if (!response.ok) {
              console.warn(`Dynamic visibility endpoint returned ${response.status} for ${item.label}`);
              // Fall back to scope-based visibility
              if (item.dynamicVisibility.fallbackScopes) {
                const hasFallbackScope = item.dynamicVisibility.fallbackScopes.some(scope => 
                  myScopes.includes(scope)
                );
                if (hasFallbackScope) {
                  return { label: item.label, href: item.href };
                }
              }
              return null;
            }
            
            const data = await response.json();
            const fieldValue = data[item.dynamicVisibility.field];
            
            // If the dynamic condition is met, show the item
            if (fieldValue === item.dynamicVisibility.value) {
              return { label: item.label, href: item.href };
            }
            
            // If dynamic condition is not met, check fallback scopes
            if (item.dynamicVisibility.fallbackScopes) {
              const hasFallbackScope = item.dynamicVisibility.fallbackScopes.some(scope => 
                myScopes.includes(scope)
              );
              if (hasFallbackScope) {
                return { label: item.label, href: item.href };
              }
            }
            
            // Neither condition met, hide the item
            return null;
          } catch (error) {
            if (error.name === 'AbortError') {
              console.warn(`Dynamic visibility check timed out for ${item.label}`);
            } else {
              console.warn(`Failed to check dynamic visibility for ${item.label}:`, error);
            }
            
            // On error, fall back to scope-based visibility if available
            if (item.dynamicVisibility.fallbackScopes) {
              const hasFallbackScope = item.dynamicVisibility.fallbackScopes.some(scope => 
                myScopes.includes(scope)
              );
              if (hasFallbackScope) {
                return { label: item.label, href: item.href };
              }
            }
            
            return null;
          }
        };
        
        // Process all items with dynamic visibility checks
        const processedItems = await Promise.all(
          filtered.map(checkDynamicVisibility)
        );
        
        const finalItems = processedItems.filter(Boolean);
        setExtNav(finalItems);
      } catch (err) {
        console.error("Failed to load extension navigation:", err);
        setExtNav([]);
      }
    };
    
    loadExtensionNav();
  }, [scopes, navItems]);

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
    if (e.target.nodeName === "svg") {
      e.target.parentElement.click()
    }
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
        destroyArraialSocket();
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
            : "bg-transparent",
        )}
      >
        <div ref={navRef} className="navbar mx-auto h-20 w-full max-w-[90rem]">
          <div className="navbar-start !w-fit basis-[80px]">
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
                      <a className="gap-2">
                        {name}
                        <ExpandMoreIcon />
                      </a>
                      <ul className="!rounded-box w-52 border border-base-300 bg-base-200 p-2 shadow">
                        {dropdown.map(
                          (
                            { name, link, disabled, external, reload },
                            index,
                          ) => (
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
                          ),
                        )}
                      </ul>
                    </li>
                  ),
              )}
              {arraialEnabled && (
                <li>
                  <LinkAdapter to="/arraial">
                    Arraial do DETI
                  </LinkAdapter>
                </li>
              )}
              {extNav
                .map((e, idx) => (
                <li key={`ext-${idx}`}>
                  <LinkAdapter to={e.href} reloadDocument>
                    {e.label}
                  </LinkAdapter>
                </li>
              ))}
            </ul>
          </div>
          {/* Jantar Gala Button */}
          {config.ENABLE_GALA && (
            <Link
              to={`${config.BASE_URL}/gala`}
              reloadDocument
              className="btn-ghost btn-sm btn-circle btn
              gap-2.5 border-0
              bg-gradient-to-r from-[#F7BBAC] to-[#C58676]
              hover:brightness-90 md:!w-fit
              md:!px-3"
            >
              <span className="hidden text-black/70 md:block">
                <span className="hidden lg:me-1 lg:inline-block">Jantar</span>
                <span className="hidden md:inline-block">Gala</span>
              </span>
              <GalaLogo className="fill-black/70" />
            </Link>
          )}

          <div className="navbar-end !w-fit grow gap-x-3 pl-3">
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
                    className="btn-outline btn-sm btn flex-nowrap !px-0.5 align-middle md:gap-2"
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
                    {!!scopes?.includes("admin") && (
                      <li>
                        <Link to="/admin/roles">
                          <SettingsIcon /> Admin
                        </Link>
                      </li>
                    )}
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
            {arraialEnabled && (
              <li>
                <LinkAdapter to="/arraial">Arraial do DETI</LinkAdapter>
              </li>
            )}
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
                      ),
                    )}
                  </ul>
                </li>
              ),
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
