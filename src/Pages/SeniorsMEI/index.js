import React, { useState, useEffect } from 'react'
import { Row, Spinner } from 'react-bootstrap';
import Image from 'react-bootstrap/Image';

import Tabs from "../../Components/Tabs/index.js";

import TextList from "../../Components/TextList";
import Typist from 'react-typist';

// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);


const SeniorsLEI = () => {

    const [people, setPeople] = useState([]);
    const [selectedYear, setSelectedYear] = useState();
    const [anos, setAnos] = useState([]);
    const [img, setImg] = useState("");

    const [loading, setLoading] = useState(true);

    useEffect(() => {
        // pegar o número de anos
        fetch(process.env.REACT_APP_API + "/seniors/courses/years?course=MEI")
            .then((response) => response.json())
            .then((response) => {
                var anos = response.data.map((curso) => curso.year).sort((a, b) => b - a);
                if (anos.length > 0) {
                    setSelectedYear(anos[0])
                    setAnos(<Tabs tabs={anos} _default={anos[0]} onChange={setSelectedYear} />)
                }
                else
                    setAnos("");
            })

    }, [])

    useEffect(() => {
        if (selectedYear == undefined) return;
        setLoading(true);

        fetch(process.env.REACT_APP_API + "/seniors?course=MEI&year=" + selectedYear)
            .then((response) => response.json())
            .then((response) => {
                console.log(response)

                setPeople(response.data.students.map(
                    (person, i) =>
                        <TextList
                            colSize={12}
                            text={person.name}
                            className="slideUpFade"
                            style={{
                                animationDelay: animationBase + animationIncrement * 0 + "s"
                            }}
                        />
                ))
                setImg(
                    <Image
                        src={process.env.REACT_APP_STATIC + response.data.image} rounded fluid
                        className="slideUpFade"
                        style={{
                            animationDelay: animationBase + animationIncrement * 0 + "s",
                            "marginBottom": 50
                        }}
                    />
                );
                console.log(selectedYear);
                console.log(people);
                setLoading(false);
            })
    }, [selectedYear])



    return (
        <div className="d-flex flex-column flex-wrap">
            <h2 className="mb-5 text-center"><Typist>Finalistas de Mestrado</Typist></h2>

            {anos}

            {
                loading
                    ?
                    <Spinner animation="grow" variant="primary" className="mx-auto mb-3" title="A carregar..." />
                    :
                    <>

                        <Row>
                            {img}
                        </Row>

                        <Row>
                            {people}
                        </Row>

                    </>
            }



        </div>
    )
}

export default SeniorsLEI;