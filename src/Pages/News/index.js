import React, { useState, useEffect } from "react";
import { Container, Button, ToggleButton, ToggleButtonGroup } from "react-bootstrap"
import NewsList from "./NewsList";

// for testing
/*
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
]; */

const News = () => {

    const [news, setNews] = useState([]);
    const [newsTypes, setNewsTypes] = useState([]);
    const [whitelist, setWhitelist] = useState([]);

    // Get initial news page from API when component renders
    useEffect(() => {
        fetch(process.env.REACT_APP_API + "/news")
            .then(response => response.json())
            .then((response) => {
                if('data' in response) {
                    setNews(response['data']);
                }
            });
    }, []);

    // Get categories from API when component renders
    useEffect(() => {
        fetch(process.env.REACT_APP_API + "/news/categories")
            .then(response => response.json())
            .then((response) => {
                if('data' in response) {
                    response['data'].forEach( c => newsTypes.push(c.category) );
                    setWhitelist(newsTypes);
                }
            });
    }, []);

    const fetchNews = () => {
        
    };

    const changePage = (p_num) => {

    };

    
    // change whitelist to selected boxes
    const handleToggles = (val) => setWhitelist(val);

    const resetToggles = () => setWhitelist(newsTypes);

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

            {newsTypes.map( t => {
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