import React from "react";
import ImageCard from "../../Components/ImageCard"
import { Col, Container, Row } from "react-bootstrap"

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
    return (
        <Container>
            {
            // TODO: this needs to be changed to the self-writing text thing,
            // "Pill" buttons for sorting and filtering
            // also, background particles (that might be in the MainLayout?)
            }
            <h1 className="text-center">Notícias</h1>
            
            <Row>
                {news.map( article => {
                    return(
                        <Col md={4} sm={6}>
                            <ImageCard
                                image={article.image}
                                title={article.name}
                                preTitle={article.type}
                                text={article.text}
                                anchor="#"
                            ></ImageCard>
                        </Col>
                    );
                })}
            </Row>
        </Container>
    );
}

export default News;