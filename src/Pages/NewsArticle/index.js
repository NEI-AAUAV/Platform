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

        fetch(process.env.REACT_APP_API + "/news/?article=" + id)
            .then(response => response.json())
            .then((response) => {
                if('data' in response) {
                    setArticle(response["data"]);
                }
                setIsLoading(false);
            });
    }, []);

    return(
        !isLoading && article != undefined &&
        <div id="article-body">
            <Row className="text-left small text-primary mb-3">
                <a className="" href="/noticias">&#10094; Voltar às notícias</a>
            </Row>
            
            <Row>
                <Image src={process.env.REACT_APP_STATIC + article.header} alt="header" className="w-100" rounded />
            </Row>

            <Row className="mt-5">
                <h2 className="text-center w-100">{article.title}</h2>
                <h4 className="text-center w-100 text-secondary">{article.category}</h4>
            </Row>

            <Row className="text-center justify-content-center mt-3">
                <Col md={4} sm={12}>
                    <h5>
                        <b>Autor: </b> 
                        <a href={"/noticias?author=" + article.authorId} title="Mais deste autor">
                            {article.author}
                        </a>
                    </h5>
                </Col>
                <Col md={4} sm={12}>
                    <h5><b>Criado em:</b> {article.created_at}</h5>
                </Col>
                {article.last_change_at != null &&
                <Col md={4} sm={12}>
                    <h5><b>Modificado em:</b> {article.last_change_at}</h5>
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