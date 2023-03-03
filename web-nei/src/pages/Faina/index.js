import React, { useState, useEffect } from 'react'
import { Row, Spinner } from 'react-bootstrap';
import Image from 'react-bootstrap/Image';
import TextList from "../../components/TextList"

import Typist from 'react-typist';
import service from 'services/NEIService';
import YearTabs from "components/YearTabs";
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
        let anos = []
        service.getFainaMandates()
            .then(response => {
                for (var i = 0; i < response.length; i++) {
                    anos.push(response[i].year)
                }
                if (anos.length > 0) {
                    setYears(anos.reverse());
                    setSelectedYear(anos[0]);
                }
            })
        setLoading(false);

    }, [])

    useEffect(() => {
        let members = []
        service.getFainaMandates()
            .then(response => {
                for (var i = 0; i < response.length; i++) {
                    if (response[i].year === selectedYear) {
                        if (response[i].image) {
                            setImg(<Image
                                src={response[i].image} rounded fluid
                                className="slideUpFade"
                                style={{
                                    animationDelay: animationBase + animationIncrement * 0 + "s",
                                    "marginBottom": 50
                                }}
                            />);
                        } else {
                            setImg(null);
                        }
                        for (var j = 0; j < response[i].members.length; j++) {
                            members.push({
                                role: response[i].members[j].role.name,
                                name: response[i].members[j].member.name
                            });
                        }
                    }
                }
                setPeople(members.map((person, i) =>
                    <TextList
                        key={i}
                        colSize={12}
                        text={person.role + " " + person.name}
                        className="slideUpFade"
                        style={{
                            animationDelay: animationBase + animationIncrement * (i + 1) + "s",
                        }}
                    />
                )
                )
            })
        setLoading(false);

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