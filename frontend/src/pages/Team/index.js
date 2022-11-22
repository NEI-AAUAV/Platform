import React, { useEffect, useState } from "react";


import Person from "./components/Person.js";
import axios from "axios";
import Tabs from "../../components/Tabs/index.js"
import TextList from "../../components/TextList/index.js"
import { Container, Row, Spinner } from 'react-bootstrap';
import Typist from 'react-typist';

import YearTabs from "components/YearTabs";
import Box from '@mui/material/Box';
import data from "components/Navbar/data.js";


// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);


const Team = () => {
    const [years, setYears] = useState([]);

    const [selectedYear, setSelectedYear] = useState(null);

    const [people, setPeople] = useState();
    const [colaborators, setColaborators] = useState();

    const [loading, setLoading] = useState(true);

    async function getMandateYears() {

        const config = {
            method: 'get',
            url: process.env.REACT_APP_API + "/team/mandates/"
        }

        let res = await axios(config)

        var anos = res.data.data.map(year =>
            year.mandato
        ).reverse();
        setYears(anos);
        setSelectedYear(anos[0]);
    }


    async function getTeamByMandate() {

        const config = {
            method: 'get',
            url: process.env.REACT_APP_API + "/team/?mandate=" + selectedYear
        }

        let res = await axios(config)

        setPeople(res.data.data.team.map((person, i) =>
            <Person
                key={person.linkedIn}
                img={process.env.REACT_APP_STATIC + person.header}
                name={person.name}
                description={person.role} linke={person.linkedIn}
                className="slideUpFade"
                style={{
                    animationDelay: animationBase + animationIncrement * i + "s",
                }}
            />
        )
        )

        setColaborators(res.data.data.colaborators.map(colab =>
            <TextList key={colab.name} colSize={4} text={colab.name} />
        )
        )

        setLoading(false);
    }

    useEffect(() => {
        getMandateYears();
    }, [])


    useEffect(() => {
        setLoading(true);

        if (selectedYear != null) {
            getTeamByMandate();
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