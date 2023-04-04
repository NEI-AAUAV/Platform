import React from "react";

import Image from "react-bootstrap/Image";
import { Container, Row, Col } from "react-bootstrap";
import "./Person.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faLinkedin } from "@fortawesome/free-brands-svg-icons";

const Logo = process.env.PUBLIC_URL + "/linkedingLogo.png";

const Person = ({ img, name, description, linke, className, style }) => {
  return (
    <div>
      {
        <Container className={className} style={style}>
          <Col
            className="mx-auto"
            style={{ textAlign: "center", marginBottom: 40 }}
          >
            <Image
              src={img}
              roundedCircle
              style={{ width: 200, marginBottom: 20 }}
            />
            <h3>{name}</h3>
            <p>{description.toUpperCase()}</p>

            

          </Col>
        </Container>
      }
    </div>
  );
};

export default Person;
