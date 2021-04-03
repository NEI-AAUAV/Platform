import React from "react";
import ImageCard from "../../Components/ImageCard"
import { Col, Row, CardDeck } from "react-bootstrap"

// for testing
const partners = [
    {
        image: process.env.PUBLIC_URL + "/logo192.png",
        name: "first partner",
        text: "lorem ipsum yabadabadaba doooo it'sa me Fred Flintstone of the stone age"
    },
    {
        image: process.env.PUBLIC_URL + "/logo512.png",
        name: "second partner",
        text: "lorem ipsum so he's finally here, performing for you. if you know the words, you can join in too! put your hands together if you wanna clap, as we take you through this monkey rap! huh! DK! Donkey Kong!"
    },
    {
        image: process.env.PUBLIC_URL + "/logo192.png",
        name: "third partner",
        text: "lorem ipsum hey vsauce michael here did you know that a square meter is also a rectangle meter"
    },
    {
        image: process.env.PUBLIC_URL + "/logo512.png",
        name: "fourth partner",
        text: "lorem ipsum ev no rvji orvireo vikv reij reivj erikvwvw  irvwei jwi rhvrrie vhjei kb"
    }
];

const Partners = () => {
    // tenho de ver como fazer o card deck responsive

    return (
        <div>
            <h1>Partners</h1>
            
            <CardDeck>
                {partners.map( partner => {
                    return(
                        //<Col xl={6}>
                            <ImageCard
                                image={partner.image}
                                title={partner.name}
                                text={partner.text}
                            ></ImageCard>
                        //</Col>
                    );
                })}
            </CardDeck>
        </div>
    );
}

export default Partners;