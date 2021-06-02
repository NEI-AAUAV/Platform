import React, {useState, useEffect} from 'react'
import {Container, Row, Col} from 'react-bootstrap';
import Image from 'react-bootstrap/Image';

import Tabs from "../../Components/Tabs/index.js";

import TextList from "../../Components/TextList"



const SeniorsLEI = () => {  

    const [people,setPeople] = useState([]);
    const [selectedYear, setSelectedYear] = useState();
    const [anos, setAnos] = useState([]);
    const [img, setImg] = useState("");

    useEffect(() => {
        // pegar o número de anos
        fetch(process.env.REACT_APP_API + "/seniors/courses/years?course=LEI")
        .then((response) => response.json())
        .then((response) => {
            var anos = response.data.map((curso) => curso.year).sort((a,b) => b-a);
            if (anos.length > 0) {
                setSelectedYear(anos[0])
                setAnos(<Tabs tabs={anos} _default={anos[0]} onChange = {setSelectedYear}/>)  
            }
            else
                setAnos("");
        })

    }, [])

    useEffect(() => {
        if (selectedYear == undefined)  return;

        fetch(process.env.REACT_APP_API + "/seniors?course=LEI&year=" + selectedYear)
        .then((response) => response.json())
        .then((response) => {
            console.log(response)
            setPeople(response.data.students.map((person) => <TextList colSize={3} text={person.name} />))
            setImg(<Image style={{"marginBottom":50}} src={response.data.image} rounded fluid />);
            console.log(selectedYear);
            console.log(people);
        })
    }, [selectedYear])



    return(
        <div>
            <h1 id="title">Finalistas de Licenciatura</h1>

            {anos}

            <Container>
                <Row>
                    {img}
                </Row>
            </Container>

            <Row>
                {people}
            </Row>
           
            

        </div>
    )
}

export default SeniorsLEI;