import React, { useState, useEffect } from "react";

import {
    Navbar as BNavbar,
    Nav,
    NavDropdown
} from "react-bootstrap";

import data from "./data";
import logo from './logo.png';
import "./index.css";

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
        <div className={transparent ? "navbardiv col-12 p-0 position-fixed bg-transparent" : "navbardiv col-12 p-0 position-fixed bg-white"}>
            <BNavbar 
                bg="transparent" 
                expand="lg" 
                className="col-12 col-md-10 mx-auto"
                onToggle={(col) => setCollapsed(col)}
            >
                <BNavbar.Brand href="/">
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
                <BNavbar.Collapse id="basic-BNavbar-nav" className="bg-white">
                    <Nav className="mr-auto">
                        {
                            data.map(
                                navEl =>
                                    !navEl.dropdown
                                        ?
                                        <Nav.Link
                                            href={navEl.link}
                                            className={
                                                window.location.pathname == navEl.link ? "active mr-3" : "mr-3"
                                            }
                                        >
                                            {navEl.name}
                                        </Nav.Link>
                                        :
                                        <NavDropdown title={navEl.name} id={"dropdown-" + navEl.name.replace(" ", "")}>
                                            {
                                                navEl.dropdown.map(
                                                    dropdown =>
                                                        <NavDropdown.Item href={dropdown.link}>{dropdown.name}</NavDropdown.Item>
                                                )
                                            }
                                        </NavDropdown>
                            )
                        }
                    </Nav>
                </BNavbar.Collapse>
            </BNavbar>
        </div>
    );

}

export default Navbar;