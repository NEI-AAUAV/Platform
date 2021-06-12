import React, {useState, useEffect} from 'react'
import { Row } from 'react-bootstrap';
import Image from 'react-bootstrap/Image';

import Tabs from "../../Components/Tabs/index.js";

import TextList from "../../Components/TextList"
import Typist from 'react-typist';


const Faina = () => {  

    const [people,setPeople] = useState([]);
    const [selectedYear, setSelectedYear] = useState();
    const [anos, setAnos] = useState([]);
    const [img, setImg] = useState(null);

    useEffect(() => {
        // pegar o número de anos
        fetch(process.env.REACT_APP_API + "/faina/mandates")
        .then((response) => response.json())
        .then((response) => {
            var anos = response.data.map((curso) => curso.mandato).sort((a,b) => b-a);
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

        fetch(process.env.REACT_APP_API + "/faina?mandate=" + selectedYear)
        .then((response) => response.json())
        .then((response) => {
            console.log(response)
            setPeople(response.data.members.map((person) => <TextList colSize={12} text={person.role + " " + person.name} />))
            if (response.data.imagem) {
                setImg(<Image style={{"marginBottom":50}} src={process.env.REACT_APP_STATIC + response.data.imagem} rounded fluid />);
            }
            console.log(selectedYear);
            console.log(people);
        })
    }, [selectedYear])



    return(
        <div>
            <h2 className="mb-5 text-center"><Typist>Comissão de Faina</Typist></h2>

            {anos}

            <Row>
                {img}
            </Row>

            <Row>
                {people}
            </Row>
           
            

        </div>
    )
}

export default Faina;