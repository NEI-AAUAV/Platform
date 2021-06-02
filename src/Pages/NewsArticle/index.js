import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { Row, Col, Image } from "react-bootstrap";
import "./index.css";

const NewsArticle = () => {

    let { id } = useParams();

    const [isLoading, setIsLoading] = useState(true);
    const [article, setArticle] = useState([]);

    // fetch article from API
    useEffect(() => {
        if (!id.match("[0-9]+"))
            window.location.href = "/404";

        fetch(process.env.REACT_APP_API + "/news?article=" + id)
            .then(response => response.json())
            .then((response) => {
                if('data' in response) {
                    setArticle(response["data"]);
                }
                setIsLoading(false);
            });
    }, []);

    return(
        isLoading ?
        <div>
            <h3 className="text-center">
                A carregar notícia...
            </h3>
        </div>

        :
        article == undefined ?
        <div>
            <h3 className="text-center">
                Notícia não encontrada...
            </h3>
        </div>

        :
        <div id="article-body">
            <Row>
                <Image src={process.env.REACT_APP_UPLOADS + article.header} alt="header" className="w-100" rounded />
            </Row>

            <Row className="mt-5">
                <h1 className="text-center w-100">{article.title}</h1>
                <h5 className="text-center w-100 text-secondary">{article.category}</h5>
            </Row>

            <Row className="text-center justify-content-center mt-3">
                <Col md={4} sm={12}>
                    <b>Autor: </b> 
                    <a href={"/noticias?author=" + article.authorId} title="Mais deste autor">
                        {article.author}
                    </a>
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
            
        </div>
    );
}

export default NewsArticle;