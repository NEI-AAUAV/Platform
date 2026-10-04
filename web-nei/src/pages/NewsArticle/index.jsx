import React, { useEffect, useMemo, useState } from "react";
import DOMPurify from "dompurify";
import { useParams, Link } from "react-router-dom";
import { Row, Col, Image } from "react-bootstrap";
import service from "services/NEIService";
import "./index.css";

const NewsArticle = () => {
  let { id } = useParams();

  const [isLoading, setIsLoading] = useState(true);
  const [article, setArticle] = useState([]);

  const sanitizedContent = useMemo(
    () => DOMPurify.sanitize(article?.content ?? ""),
    [article?.content]
  );

  // fetch article from API
  useEffect(() => {
    if (!id.match("[0-9]+")) window.location.href = "/404";

    service
      .getNewsById(id)
      .then((data) => {
        setArticle(data);
        setIsLoading(false);
      })
      .catch((error) => {
        console.error("Failed to load news article:", error);
      });
  }, []);

  return (
    !isLoading &&
    article != undefined && (
      <div id="article-body">
        <Row className="small mb-3 text-left text-primary">
          <Link to="/news">&#10094; Voltar às notícias</Link>
        </Row>

        <Row>
          {article.header && (
            <Image src={article.header} alt="header" className="w-100" rounded />
          )}
        </Row>

        <Row className="mt-5">
          <h2 className="w-100 text-center">{article.title}</h2>
          <h4 className="w-100 text-center text-secondary">
            {article.category}
          </h4>
        </Row>

        <Row className="justify-content-center mt-3 text-center">
          <Col md={4} sm={12}>
            <h5>
              <b>Autor: </b>
              <a
                href={"/news?author=" + article.author_id}
                title="Mais deste autor"
              >
                {article.author?.name}
              </a>
            </h5>
          </Col>
          <Col md={4} sm={12}>
            <h5>
              <b>Criado em:</b> {article.created_at?.split("T").at(0)}
            </h5>
          </Col>
          {article.updated_at != null && (
            <Col md={4} sm={12}>
              <h5>
                <b>Modificado em:</b> {article.updated_at?.split("T").at(0)}
              </h5>
            </Col>
          )}
        </Row>

        <div
          className="mt-4 text-justify"
          style={{ color: "var(--text-primary)" }}
        >
          {/* Content is HTML from the API: sanitized with DOMPurify first */}
          <p dangerouslySetInnerHTML={{ __html: sanitizedContent }}></p>
        </div>

        {/* idea: a button to go back to news page, with previous filters? */}
      </div>
    )
  );
};

export default NewsArticle;
