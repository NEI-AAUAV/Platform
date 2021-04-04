import React from "react";
import "./index.css";


import Person from "./Components/Person.js";
import {Container, Row, Col} from 'react-bootstrap';

const data = [
    { 
        name: "Lucius Vinicius", 
        description: "Líder da nova ordem mundial", 
        img: process.env.PUBLIC_URL + "/perfil-teste.jpeg",
        linke: "https://www.linkedin.com/in/lucius-vinicius-rocha-machado-filho-a929931a9/"
    },
    { 
        name: "Pedro Figueiredo", 
        description: "Responsável Financeiro", 
        img: process.env.PUBLIC_URL + "/perfil-teste.jpeg"
    },
    { 
        name: "Ramdom Person", 
        description: "Random Description", 
        img: process.env.PUBLIC_URL + "/perfil-teste.jpeg",
        linke: "https://www.linkedin.com/in/lucius-vinicius-rocha-machado-filho-a929931a9/"
    },
    { 
        name: "Ramdom Person", 
        description: "Random Description", 
        img: process.env.PUBLIC_URL + "/perfil-teste.jpeg",
        linke: "https://www.linkedin.com/in/lucius-vinicius-rocha-machado-filho-a929931a9/"
    }
]

const people = data.map(person => <Person
    img = {person.img} name = {person.name} description = {person.description} linke={person.linke}/>);

const Team = () => {
    return (
        <div>
            <h1 id="title">Equipa do NEI</h1>
            {
                // Fazer anos
            }
            <Row xs={1} md = {3} lg={3}>
                {people}
            </Row>

        </div>
    );
}

export default Team;