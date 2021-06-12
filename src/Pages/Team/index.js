import React, { useEffect, useState } from "react";


import Person from "./Components/Person.js";
import Tabs from "../../Components/Tabs/index.js"
import TextList from "../../Components/TextList/index.js"
import {Container, Row } from 'react-bootstrap';
import Typist from 'react-typist';


const Team = () => {
    const [years,setYears] = useState([]);

    const [selectedYear,setSelectedYear] = useState(null);

    const [people,setPeople] = useState();
    const [colaborators,setColaborators] = useState();

    const yearsC = years.map((el, index) => <Tabs year={years[index]} func={setSelectedYear}/>)


    useEffect(() => {
        fetch(process.env.REACT_APP_API+"/team/mandates")
        .then(response => response.json())
        .then((response) => {
            var anos = response.data.map(year => 
                year.mandato
            ).sort((a,b) => b-a);
            setYears(anos)
            setSelectedYear(anos[0])
        })
        
    }, [])


    useEffect(() => {
        if (selectedYear != null){
            fetch(process.env.REACT_APP_API+"/team?mandate="+selectedYear)
            .then(response => response.json())
            .then(
                (response) => {
                var resp = response.data

                setPeople(resp.team.map(person => 
                    <Person
                        img = {process.env.REACT_APP_UPLOADS + person.header} 
                        name = {person.name} 
                        description = {person.role} linke={person.linkedIn} 
                    />
                ))

                setColaborators(resp.colaborators.map(colab => 
                    <TextList colSize={4} text={colab.name}/>
                ))
            })
        }
    }, [selectedYear])





    return (
        <div>
            <h2 className="mb-5 text-center"><Typist>Equipa do NEI</Typist></h2>

            <Tabs tabs={years} _default={selectedYear} onChange={setSelectedYear} />
            

                <Row xs={1} lg={3}>
                    {people}
                </Row>

            {
            colaborators != null && colaborators.length > 0 && 
                <Row className="justify-content-center">
                    <h2>Colaboradores</h2>
                </Row>
                
            }

            <Container>
                <Row xs={1} lg={3}>
                    {colaborators}
                </Row>
            </Container>
            
            

        </div>
    ); 
}

export default Team;