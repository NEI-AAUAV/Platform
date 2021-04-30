import React, { useEffect, useState } from "react";
import { Container, Row, Col, Image } from "react-bootstrap";
import "./index.css";

const NewsArticle = () => {

    const [isLoading, setIsLoading] = useState(true);
    const [article, setArticle] = useState([]);

    // fetch article from API
    useEffect(() => {
        const newsId = window.location.search;
        console.log(newsId);

        fetch(process.env.REACT_APP_API + "/news" + newsId)
            .then(response => response.json())
            .then((response) => {
                if('data' in response) {
                    setIsLoading(false);
                    setArticle(response["data"]);
                }
            });
    }, []);

    return(
        isLoading ?
        <Container>
            <h3 className="text-center">
                A carregar notícia...
            </h3>
        </Container>
        :
        article == undefined ?
        <Container>
            <h3 className="text-center">
                Notícia não encontrada...
            </h3>
        </Container>
        :
        <Container id="article-body">
            <Row>
                <Image src={process.env.REACT_APP_UPLOADS + article.header} alt="header" className="w-100" rounded />
            </Row>
            <Row className="mt-5">
                <h1 className="text-center w-100">{article.title}</h1>
                <h5 className="text-center w-100 text-secondary">{article.category}</h5>
            </Row>
            <Row className="text-center justify-content-center mt-3">
                <Col md={4} sm={12}>
                    <b>Autor:</b> {article.author ? article.author : "NEI"}
                    <br/>
                    <a href={"noticias?author=" + article.authorId}>Mais deste autor</a>
                </Col>
                <Col md={4} sm={12}>
                    <b>Criado em:</b> {article.created_at}
                </Col>
                {article.last_change_at != null &&
                <Col md={4} sm={12}>
                    <b>Modificado em:</b> {article.last_change_at}
                </Col>
                }
            </Row>
            <Row className="mt-4 text-justify">
                { /* this seems bad, maybe use this instead: https://github.com/remarkablemark/html-react-parser */ }
                <p dangerouslySetInnerHTML={{__html: article.content}}></p>
            </Row>

            { /* idea: a button to go back to news page, with previous filters? */ }
            
        </Container>
    );
}

export default NewsArticle;