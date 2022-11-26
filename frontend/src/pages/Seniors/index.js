import { useState, useEffect, Fragment } from 'react'
import { useParams } from 'react-router';
import { Row, Spinner } from 'react-bootstrap';
import Image from 'react-bootstrap/Image';

import TextList from "../../components/TextList";
import SeniorsCard from "./SeniorsCard";
import Typist from 'react-typist';

import service from 'services/NEIService';

import YearTabs from "components/YearTabs";
import Box from '@mui/material/Box';


// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);


const Seniors = () => {

    // get course from URL parameters
    let { id } = useParams();

    let animKey = 0; // index for delaying animations

    const [people, setPeople] = useState([]);
    const [years, setYears] = useState([]);
    const [selectedYear, setSelectedYear] = useState();
    const [img, setImg] = useState();

    const [namesOnly, setNamesOnly] = useState(false);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        setYears(null); // hack to update typist title

        // get list of courses to check if 'id' is valid
        service.getSeniorsCourse()
            .then((data) => {
                if (!data.includes(id)) {
                    throw new Error("Not available");
                }
            }).catch(() => {
                window.location.href = "/404";
            });


        // pegar o número de anos
        service.getSeniorsCourseYear(id)
            .then((data) => {
                var anos = data.sort((a, b) => b - a);
                if (anos.length > 0) {
                    setYears(anos);
                    setSelectedYear(anos[0]);
                }
                else {
                    throw new Error("Not available");
                }
            }).catch(() => {
                window.location.href = "/404";
            });
    }, [id])

    useEffect(() => {
        if (selectedYear === undefined) return;
        setLoading(true);

        service.getSeniorsBy(id, selectedYear)
            .then((data) => {
                if (!data) {
                    throw new Error("Not available");
                }
                setNamesOnly(data.students[0]["quote"] == null &&
                    data.students[0]["image"] == null);
                setPeople(data.students);
                setImg(
                    <Image
                        src={data.image}
                        rounded
                        fluid
                        className="slideUpFade"
                        style={{
                            animationDelay: animationBase + animationIncrement * 0 + "s",
                            "marginBottom": 50
                        }}
                    />
                );
                setLoading(false);
            }).catch(() => {
                window.location.href = "/404";
            });
    }, [selectedYear, id])

    return (
        <div className="d-flex flex-column flex-wrap pb-5 mb-5">
            <h2 className="mb-5 text-center">
                {years && <Typist>{"Finalistas de " + id}</Typist>}
            </h2>
            <Box sx={{ maxWidth: { xs: "100%", md: "900px" }, margin: "auto", marginBottom: "50px" }}>
                {console.log(years)}

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
                        {
                            namesOnly &&
                            <Row>{img}</Row>
                        }
                        <Row>
                            {
                                namesOnly ?
                                    people?.map((person, index) =>
                                        <Fragment key={index}>
                                            <TextList
                                                colSize={3}
                                                text={person.user?.name}
                                                className="slideUpFade"
                                                style={{
                                                    animationDelay: animationBase + animationIncrement * 0 + "s"
                                                }}
                                            />
                                        </Fragment>
                                    )
                                    :
                                    people?.map((person, index) =>
                                        <Fragment key={index}>
                                            <SeniorsCard
                                                name={person.user?.name}
                                                quote={person.quote}
                                                image={person.image}
                                                colSizeXs="12"
                                                colSizeSm="6"
                                                colSizeLg="4"
                                                colSizeXl="3"
                                                className="slideUpFade"
                                                style={{
                                                    animationDelay: animationBase + animationIncrement * animKey++ + "s"
                                                }}
                                            />
                                        </Fragment>
                                    )
                            }
                        </Row>
                    </>
            }
        </div>
    )
}

export default Seniors;