import React from "react";
import ImageCard from "../../Components/ImageCard"
import { Col, Container, Row } from "react-bootstrap"

// for testing
const partners = [
    {
        image: process.env.PUBLIC_URL + "/testImage.jpg",
        name: "first partner",
        text: "lorem ipsum yabadabadaba doooo it'sa me Fred Flintstone of the stone age"
    },
    {
        image: process.env.PUBLIC_URL + "/testImage.jpg",
        name: "second partner",
        text: "lorem ipsum so he's finally here, performing for you. if you know the words, you can join in too! put your hands together if you wanna clap, as we take you through this monkey rap! huh! DK! Donkey Kong!"
    },
    {
        image: process.env.PUBLIC_URL + "/testImage.jpg",
        name: "third partner",
        text: "lorem ipsum hey vsauce michael here did you know that a square meter is also a rectangle meter"
    },
    {
        image: process.env.PUBLIC_URL + "/testImage.jpg",
        name: "fourth partner",
        text: "lorem ipsum ev no rvji orvireo vikv reij reivj erikvwvw  irvwei jwi rhvrrie vhjei kb"
    }
];

const Partners = () => {
    return (
        <Container>
            {
            // TODO: this needs to be changed to the self-writing text thing
            // also, background particles (that might be in the MainLayout?)
            }
            <h1 className="text-center">Parceiros</h1>
            
            <Row>
                {partners.map( partner => {
                    return(
                        <Col md={6}>
                            <ImageCard
                                image={partner.image}
                                title={partner.name}
                                text={partner.text}
                                anchor="#"
                                dark_mode="on"
                            ></ImageCard>
                        </Col>
                    );
                })}
            </Row>
        </Container>
    );
}

export default Partners;