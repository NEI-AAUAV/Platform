import { useState, useEffect, Fragment } from 'react'
import { useParams } from 'react-router';
import { Row, Spinner } from 'react-bootstrap';
import Image from 'react-bootstrap/Image';
import Tabs from "../../Components/Tabs/index.js";
import TextList from "../../Components/TextList";
import SeniorsCard from "./SeniorsCard";
import Typist from 'react-typist';


// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);


const Seniors = () => {

    // get course from URL parameters
    let { id } = useParams();

    let animKey = 0; // index for delaying animations

    const [people, setPeople] = useState([]);
    const [selectedYear, setSelectedYear] = useState();
    const [anos, setAnos] = useState();
    const [img, setImg] = useState();

    const [namesOnly, setNamesOnly] = useState(false);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        setAnos(null); // hack to update typist title

        // get list of courses to check if 'id' is valid
        fetch(process.env.REACT_APP_API + "/seniors/courses/")
            .then((response) => response.json())
            .then((response) => {
                let courses = response["data"].map(el => el["course"]);
                if (!courses.includes(id)) {
                    throw new Error("Not available");
                }
            }).catch((error) => {
                window.location.href = "/404";
            });


        // pegar o número de anos
        fetch(process.env.REACT_APP_API + "/seniors/courses/years/?course=" + id)
            .then((response) => response.json())
            .then((response) => {
                var anos = response.data.map((curso) => curso.year).sort((a, b) => b - a);
                if (anos.length > 0) {
                    setSelectedYear(anos[0])
                    setAnos(<Tabs tabs={anos} _default={anos[0]} onChange={setSelectedYear} />)
                }
                else {
                    throw new Error("Not available");
                }
            }).catch((error) => {
                window.location.href = "/404";
            });
    }, [id])

    useEffect(() => {
        if (selectedYear === undefined) return;
        setLoading(true);

        fetch(process.env.REACT_APP_API + "/seniors/?course=" + id + "&year=" + selectedYear)
            .then((response) => response.json())
            .then((response) => {
                setNamesOnly(response.data.students[0]["quote"] == null &&
                    response.data.students[0]["image"] == null);
                setPeople(response.data.students);
                setImg(
                    <Image
                        src={process.env.REACT_APP_STATIC + response.data.image}
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
            }).catch((error) => {
                window.location.href = "/404";
            });
    }, [selectedYear, id])

    return (
        <div className="d-flex flex-column flex-wrap pb-5 mb-5">
            <h2 className="mb-5 text-center">
                {anos && <Typist>{"Finalistas de " + id}</Typist>}
            </h2>
            {anos}
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
                                    people.map((person, index) =>
                                        <Fragment key={index}>
                                            <TextList
                                                colSize={3}
                                                text={person.name}
                                                className="slideUpFade"
                                                style={{
                                                    animationDelay: animationBase + animationIncrement * 0 + "s"
                                                }}
                                            />
                                        </Fragment>
                                    )
                                    :
                                    people.map((person, index) =>
                                        <Fragment key={index}>
                                            <SeniorsCard
                                                name={person.name}
                                                quote={person.quote}
                                                image={process.env.REACT_APP_STATIC + person.image}
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