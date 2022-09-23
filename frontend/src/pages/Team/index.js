import React, { useEffect, useState } from "react";


import Person from "./components/Person.js";
import Tabs from "../../components/Tabs/index.js"
import TextList from "../../components/TextList/index.js"
import { Container, Row, Spinner } from 'react-bootstrap';
import Typist from 'react-typist';

import YearTabs from "components/YearTabs";
import Box from '@mui/material/Box';


// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);


const Team = () => {
    const [years, setYears] = useState([]);

    const [selectedYear, setSelectedYear] = useState(null);

    const [people, setPeople] = useState();
    const [colaborators, setColaborators] = useState();

    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch(process.env.REACT_APP_API + "/team/mandates/")
            .then(response => response.json())
            .then((response) => {
                var anos = response.data.map(year =>
                    year.mandato
                ).sort((a, b) => b - a);
                setYears(anos);
                setSelectedYear(anos[0]);
            })
    }, [])


    useEffect(() => {
        setLoading(true);

        if (selectedYear != null) {
            fetch(process.env.REACT_APP_API + "/team/?mandate=" + selectedYear)
                .then(response => response.json())
                .then(
                    (response) => {
                        var resp = response.data

                        setPeople(resp.team.map((person, i) =>
                            <Person
                                img={process.env.REACT_APP_STATIC + person.header}
                                name={person.name}
                                description={person.role} linke={person.linkedIn}
                                className="slideUpFade"
                                style={{
                                    animationDelay: animationBase + animationIncrement * i + "s",
                                }}
                            />
                        ))

                        setColaborators(resp.colaborators.map(colab =>
                            <TextList colSize={4} text={colab.name} />
                        ));

                        setLoading(false);
                    })
        }
    }, [selectedYear])

    return (
        <div className="d-flex flex-column flex-wrap">
            <h2 className="mb-5 text-center"><Typist>Equipa do NEI</Typist></h2>

            <Box sx={{ maxWidth: { xs: "100%", md: "700px" }, margin: "auto", marginBottom: "50px" }}>
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
                    </>
            }
        </div>
    );
}

export default Team;