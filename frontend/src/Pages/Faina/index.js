import React, { useState, useEffect } from 'react'
import { Row, Spinner } from 'react-bootstrap';
import Image from 'react-bootstrap/Image';
import TextList from "../../Components/TextList"

import Typist from 'react-typist';

import YearTabs from "Components/YearTabs";
import Box from '@mui/material/Box';


// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);

const Faina = () => {

    const [people, setPeople] = useState([]);
    const [years, setYears] = useState([]);
    const [selectedYear, setSelectedYear] = useState();
    const [img, setImg] = useState(null);

    const [loading, setLoading] = useState(true);

    useEffect(() => {
        // pegar o número de anos
        fetch(process.env.REACT_APP_API + "/faina/mandates/")
            .then((response) => response.json())
            .then((response) => {
                let anos = response.data.map((curso) => curso.mandato).sort((a, b) => parseInt(b.split('/')[0]) - parseInt(a.split('/')[0]));
                if (anos.length > 0) {
                    setYears(anos);
                    setSelectedYear(anos[0]);
                }
            });
    }, [])

    useEffect(() => {
        setLoading(true);
        if (selectedYear == undefined) return;

        fetch(process.env.REACT_APP_API + "/faina/?mandate=" + selectedYear)
            .then((response) => response.json())
            .then((response) => {
                setPeople(response.data.members.map(
                    (person, i) =>
                        <TextList
                            key={i}
                            colSize={12}
                            text={person.role + " " + person.name}
                            className="slideUpFade"
                            style={{
                                animationDelay: animationBase + animationIncrement * (i + 1) + "s",
                            }}
                        />
                ))
                if (response.data.imagem) {
                    setImg(<Image
                        src={process.env.REACT_APP_STATIC + response.data.imagem} rounded fluid
                        className="slideUpFade"
                        style={{
                            animationDelay: animationBase + animationIncrement * 0 + "s",
                            "marginBottom": 50
                        }}
                    />);
                } else {
                    setImg(null);
                }
                setLoading(false);
            })
    }, [selectedYear])

    return (
        <div className="d-flex flex-column flex-wrap">

            <div style={{ whiteSpace: 'pre', overflowWrap: 'break-word' }}>
                <h2 className="mb-5 text-center">
                    <Typist>Comissão de Faina</Typist>
                </h2>
            </div>

            <Box sx={{ maxWidth: { xs: "100%", md: "900px" }, margin: "auto", marginBottom: "50px" }}>
                <YearTabs
                    years={years}
                    value={selectedYear}
                    onChange={setSelectedYear}
                />
            </Box>
            {
                loading
                    ?
                    <Spinner animation="grow" variant="primary" className="mx-auto mb-3" title="A carregar..." />
                    :
                    <>
                        <Row>{img}</Row>
                        <Row>{people}</Row>
                    </>
            }
        </div>
    )
}

export default Faina;