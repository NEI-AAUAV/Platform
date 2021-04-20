import React, { useEffect, useState } from "react";
import "./index.css";


import Person from "./Components/Person.js";
import Year from "./Components/Year.js"
import {Container, Row, Col} from 'react-bootstrap';



const years = [2021, 2020, 2019, 2018, 2017, 2016, 2015, 2014, 2013]; // Array unico dos anos




const Team = () => {

    const [selectedYear,setSelectedYear] = useState(2021);

    const [people,setPeople] = useState();

    const yearsC = years.map((el, index) => <Year year={years[index]} func={setSelectedYear}/>)

    useEffect(() => {

        fetch("http://localhost:8000/api/team?mandate="+selectedYear)
        .then(response => response.json())
        .then((response) => {
            console.log(response.data)
            setPeople(response.data.map(person => 
                <Person
                    img = {process.env.PUBLIC_URL + person.header} 
                    name = {person.name} 
                    description = {person.title} linke={person.linkedIn} 
                />
            ))
        })
    }, [selectedYear])




    return (
        <div>
            <h1 id="title">Equipa do NEI</h1>

            <Container>
                <Row className="justify-content-center">
                    {yearsC}    
                </Row>
            </Container>
            

            <Container>
                <Row xs={1} lg={3}>
                    {people}
                </Row>
            </Container>

        </div>
    ); 
}

export default Team;