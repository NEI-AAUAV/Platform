import React, { useState, useEffect } from "react";
import { Row, Container, Button, ToggleButton, ToggleButtonGroup, Accordion, Card } from "react-bootstrap"
import NewsList from "./NewsList";
import PageNav from "../../Components/PageNav";

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

    const [currPage, setCurrPage] = useState(1);
    const [totalPages, setTotalPages] = useState(1);
    const [apiString, setApiString] = useState("/news?");

    /** Get given news page from API */
    const fetchPage = (p_num) => {
        console.log("currPage: " + currPage + ", new_page: " + p_num);
        console.log("apiString: " + apiString);

        fetch(process.env.REACT_APP_API + apiString + "page=" + p_num)
            .then(response => response.json())
            .then((response) => {
                if('data' in response) {
                    setCurrPage(p_num);
                    setTotalPages(response["page"].pagesNumber);
                    setNews(response['data']);
                }
            });
    };

    // Get initial news page from API when component renders, and when apiString is changed
    useEffect( () => {fetchPage(1)}, [apiString]);

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


    // passed to PageNav component as a callback
    const handlePage = (e) => {
        console.log(e);
        //console.log(e.target.attributes.value);
        // will sometimes crash, provavelmente quando o componente PageNav ainda não finalizou o re-render 
        if (e.target.attributes.value == undefined)
            var val = e.target.parentElement.attributes.value.value;
        else
            var val = e.target.attributes.value.value;

        if (val == "prev")
            fetchPage(currPage-1);
        else if (val == "next")
            fetchPage(currPage/1 +1);
        else
            fetchPage(val);
    }

    // change whitelist to selected boxes and update apiString
    const handleToggles = (val) => {
        setWhitelist(val);

        var str = "/news?";

        if (val != newsTypes) {
            val.forEach( v => {
                str = str + "category[]=" + v + "&"; 
            });
        }
        setApiString(str);
    };

    const resetToggles = () => handleToggles(newsTypes);


    return (
        <Container>
            {
            // TODO: this needs to be changed to the self-writing text thing,
            // also, background particles (that might be in the MainLayout?)
            }
            <h1 className="text-center">Notícias</h1>

            <Accordion>
                <div className="d-flex justify-content-between mt-4">
                    <Accordion.Toggle as={Button} variant="success" className="mb-3" eventKey="1">
                        Filters
                    </Accordion.Toggle>

                    <PageNav page={currPage} total={totalPages} handler={handlePage}></PageNav>
                </div>

                <Accordion.Collapse eventKey="1">
                    <div className="pt-3 mb-3 border-top">
                        <Button variant="outline-success" className="mr-4" onClick={resetToggles}>
                            Tudo
                        </Button>

                        {newsTypes.map( t => {
                            return (
                                <ToggleButtonGroup type="checkbox" value={whitelist} onChange={handleToggles} className="mr-2" key={t}>
                                    <ToggleButton variant="outline-success pill" className="rounded-pill" value={t}>
                                        {t}
                                    </ToggleButton>
                                </ToggleButtonGroup>
                            );
                        })}
                    </div>
                </Accordion.Collapse>
            </Accordion>

            <NewsList news={news}></NewsList>

        </Container>
    );
}

export default News;