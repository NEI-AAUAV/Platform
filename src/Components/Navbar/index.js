import React from "react";

import {
    Navbar as BNavbar,
    Nav,
    NavDropdown
} from "react-bootstrap";

import data from "./data";

const Navbar = () => {

    return (
        <BNavbar bg="light" expand="lg">
            <BNavbar.Brand href="/">NEI</BNavbar.Brand>
            <BNavbar.Toggle aria-controls="basic-BNavbar-nav" />
            <BNavbar.Collapse id="basic-BNavbar-nav">
                <Nav className="mr-auto">
                    {
                        data.map(
                            navEl =>
                            navEl.link != "" ?
                            <Nav.Link 
                                href={navEl.link}
                                className={
                                    window.location.pathname==navEl.link && "active"
                                }
                            > 
                                {navEl.name}
                            </Nav.Link>
                            : <NavDropdown title={navEl.name}>
                                {
                                navEl.drop.map(
                                    item => <NavDropdown.Item
                                        href={item.link}
                                    >
                                        {item.name}
                                    </NavDropdown.Item>
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