import React, { useState } from "react";
import { Container, Button, ToggleButton, ToggleButtonGroup } from "react-bootstrap"
import NewsList from "./NewsList";

// for testing
const news = [
    {
        image: process.env.PUBLIC_URL + "/testImage.jpg",
        name: "Article Uno",
        type: "Event",
        text: "22-10-2021"
    },
    {
        image: process.env.PUBLIC_URL + "/testImage.jpg",
        name: "Article Two",
        type: "Event",
        text: "19-10-2021"
    },
    {
        image: process.env.PUBLIC_URL + "/testImage.jpg",
        name: "Article San",
        type: "Review",
        text: "18-10-2021"
    },
    {
        image: process.env.PUBLIC_URL + "/testImage.jpg",
        name: "Article Quatro",
        type: "Info",
        text: "12-10-2021"
    },
    {
        image: process.env.PUBLIC_URL + "/testImage.jpg",
        name: "Article o Quinto",
        type: "Event",
        text: "9-10-2021"
    }
];

const News = () => {
    // get set of news types
    var news_types = [];    // need to use array instead of Set for map() to work
    news.forEach( n => {
        if (! news_types.includes(n.type))
            news_types.push(n.type);
    });

    // set of news types to show
    const [whitelist, setWhitelist] = useState(news_types);
    // change whitelist to selected boxes
    const handleToggles = (val) => setWhitelist(val);

    const resetToggles = () => {
        setWhitelist(news_types);
    }

    return (
        <Container>
            {
            // TODO: this needs to be changed to the self-writing text thing,
            // "Pill" buttons for sorting and filtering
            // also, background particles (that might be in the MainLayout?)
            }
            <h1 className="text-center">Notícias</h1>

            <Button variant="outline-success" onClick={resetToggles}>
                Tudo
            </Button>

            {news_types.map( t => {
                return (
                    <ToggleButtonGroup type="checkbox" value={whitelist} onChange={handleToggles}>
                        <ToggleButton variant="outline-success" value={t}>
                            {t}
                        </ToggleButton>
                    </ToggleButtonGroup>
                );
            })}
            
            <NewsList
                news={news}
                whitelist={whitelist}
            ></NewsList>
        </Container>
    );
}

export default News;