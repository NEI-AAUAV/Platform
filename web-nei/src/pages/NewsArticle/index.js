import React, { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import { Row, Col, Image } from "react-bootstrap";
import service from 'services/NEIService';
import "./index.css";

const NewsArticle = () => {

    let { id } = useParams();

    const [isLoading, setIsLoading] = useState(true);
    const [article, setArticle] = useState([]);

    // fetch article from API
    useEffect(() => {
        if (!id.match("[0-9]+"))
            window.location.href = "/404";

        service.getNewsById(id)
            .then((data) => {
                setArticle(data);
                setIsLoading(false);
            });
    }, []);

    return (
        !isLoading && article != undefined &&
        <div id="article-body">
            <Row className="text-left small text-primary mb-3">
                <Link to="/noticias">&#10094; Voltar às notícias</Link>
            </Row>

            <Row>
                <Image src={article.header} alt="header" className="w-100" rounded />
            </Row>

            <Row className="mt-5">
                <h2 className="text-center w-100">{article.title}</h2>
                <h4 className="text-center w-100 text-secondary">{article.category}</h4>
            </Row>

            <Row className="text-center justify-content-center mt-3">
                <Col md={4} sm={12}>
                    <h5>
                        <b>Autor: </b>
                        <a href={"/noticias?author=" + article.author_id} title="Mais deste autor">
                            {article.author?.name}
                        </a>
                    </h5>
                </Col>
                <Col md={4} sm={12}>
                    <h5><b>Criado em:</b> {article.created_at?.split('T').at(0)}</h5>
                </Col>
                {article.last_change_at != null &&
                    <Col md={4} sm={12}>
                        <h5><b>Modificado em:</b> {article.last_change_at?.split('T').at(0)}</h5>
                    </Col>
                }
            </Row>

            <div className="mt-4 text-justify" style={{color: 'var(--text-primary)'}}>
                { /* this seems bad, maybe use this instead: https://github.com/remarkablemark/html-react-parser */}
                <p dangerouslySetInnerHTML={{ __html: article.content }}></p>
            </div>

            { /* idea: a button to go back to news page, with previous filters? */}

        </div>
    );
}

export default NewsArticle;