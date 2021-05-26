import React from "react";

import {
    Navbar as BNavbar,
    Nav,
    NavDropdown
} from "react-bootstrap";

import data from "./data";
import logo from './logo.png';
import "./index.css";

const Navbar = () => {

    return (
        <BNavbar bg="transparent" expand="lg" className="col-10 mx-auto my-4">
            <BNavbar.Brand href="/">
                <img
                    src={logo}
                    width="75"
                    height="75"
                    className="d-inline-block align-top mr-5"
                    alt="NEI"
                />
            </BNavbar.Brand>
            <BNavbar.Toggle aria-controls="basic-BNavbar-nav" />
            <BNavbar.Collapse id="basic-BNavbar-nav">
                <Nav className="mr-auto">
                    {
                        data.map(
                            navEl =>
                                !navEl.dropdown 
                                ?    
                                <Nav.Link 
                                    href={navEl.link}
                                    className={
                                        window.location.pathname==navEl.link ? "active mr-3" : "mr-3"
                                    }
                                >
                                    {navEl.name}
                                </Nav.Link>
                                :
                                <NavDropdown title={navEl.name} id={"dropdown-"+navEl.name.replace(" ", "")}>
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
    );

}

export default Navbar;