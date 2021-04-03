import React from "react";
import "./index.css";


import Person from "./Components/Person.js";
import {Container, Row, Col} from 'react-bootstrap';

const data = [{ name: "Lucius Vinicius", description: "Líder da nova ordem mundial"

}]


const Team = () => {
    return (
        <div>
            <h1 id="title">Equipa do NEI</h1>
            {
                // Fazer anos
            }
            <Row xs={1} md = {3} lg={3}>
                <Person 
                    img={process.env.PUBLIC_URL + "/perfil-teste.jpeg"}
                    name="Lucius Vinicius"
                    description="Líder da nova ordem mundial"
                />
                <Person 
                    img={process.env.PUBLIC_URL + "/perfil-teste.jpeg"}
                    name="Random Person"
                    description="Do some stuff"
                />
            </Row>

        </div>
    );
}

export default Team;