import React, { useState, useEffect, Fragment } from "react";

import {
    Navbar as BNavbar,
    Nav,
    NavDropdown
} from "react-bootstrap";

import { Link } from "react-router-dom";

import data from "./data";
import logo from './logo.png';
import "./index.css";
import { link } from "d3";

const Navbar = () => {
    const [transparent, setTransparent] = useState(true);
    const [collapsed, setCollapsed] = useState(false);

    // On scrool, make bg white
    useEffect(() => {
        window.addEventListener('scroll', (event) => {
            // Get scroll position
            if (window.pageYOffset > 20) {
                setTransparent(false);
            } else {
                setTransparent(true);
            }
        });
    }, []);

    return (
        <div className={transparent ? "navbardiv col-12 p-0 position-fixed" : "navbardiv col-12 p-0 position-fixed"}>
            <BNavbar
                bg="transparent"
                expand="lg"
                className="px-0 col-11 col-sm-10 col-xxl-9 mx-auto navBar"
                onToggle={(col) => setCollapsed(col)}
            >
                <BNavbar.Brand as={Link} to="/">
                    <img
                        src={logo}
                        width="75"
                        height="75"
                        className="d-inline-block align-top mr-5"
                        alt="NEI"
                    />
                </BNavbar.Brand>
                <BNavbar.Toggle aria-controls="basic-BNavbar-nav">
                    <div
                        className={collapsed ? "hamburguer open" : "hamburguer"}
                    >
                        <span></span>
                        <span></span>
                        <span></span>
                        <span></span>
                    </div>
                </BNavbar.Toggle>
                <BNavbar.Collapse id="basic-BNavbar-nav" className=" small font-weight-bold">
                    <Nav className="mr-auto">
                        {
                            data.filter(d => d).map(
                                (navEl, index) =>
                                    <Fragment key={index}>
                                        {!navEl.dropdown
                                            ?
                                            <Nav.Link
                                                as={Link}
                                                to={navEl.link}
                                                className={
                                                    window.location.pathname == navEl.link ? "active" : ""
                                                }
                                                target={navEl.external && "_blank"}
                                                rel={navEl.external && "noreferrer"}
                                            >
                                                {navEl.name}
                                            </Nav.Link>
                                            :
                                            <NavDropdown title={navEl.name} id={"dropdown-" + navEl.name.replace(" ", "")}>
                                                {
                                                    navEl.dropdown.filter(d => d).map(
                                                        (dropdown, index) =>
                                                            <NavDropdown.Item
                                                                key={index}
                                                                {...(dropdown.external ? { href: dropdown.link } : { as: Link, to: dropdown.link })}
                                                                target={dropdown.external && "_blank"}
                                                                rel={dropdown.external && "noreferrer"}
                                                            >{dropdown.name}
                                                            </NavDropdown.Item>
                                                    )
                                                }
                                            </NavDropdown>
                                        }
                                    </Fragment>
                            )
                        }
                    </Nav>
                </BNavbar.Collapse>
            </BNavbar>
        </div>
    );

}

export default Navbar;