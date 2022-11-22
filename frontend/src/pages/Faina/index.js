import React, { useState, useEffect } from 'react'
import { Row, Spinner } from 'react-bootstrap';
import Image from 'react-bootstrap/Image';
import TextList from "../../components/TextList"

import Typist from 'react-typist';
import axios from "axios";
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

    const getFainaMandates = async () => {

        const config = {
            method: 'get',
            url: process.env.REACT_APP_API + "/faina/mandates/"
        }

        let res = await axios(config)

        var anos = res.data.data.map(year =>
            year.mandato
        ).reverse();

        if (anos.length > 0) {
            setYears(anos);
            setSelectedYear(anos[0]);
        }
    }

    const getFainaByMandate = async () => {

        setLoading(true);
        if (selectedYear == undefined) return;

        const config = {
            method: 'get',
            url: process.env.REACT_APP_API + "/faina/?mandate=" + selectedYear
        }

        let res = await axios(config)

        setPeople(res.data.data.members.map((person, i) =>
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

        if (res.data.data.imagem) {
            setImg(<Image
                src={process.env.REACT_APP_STATIC + res.data.data.imagem} rounded fluid
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
    }


    useEffect(() => {
        getFainaMandates();
    }, [])

    useEffect(() => {
        getFainaByMandate();
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