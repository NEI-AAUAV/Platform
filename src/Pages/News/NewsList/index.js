import React from "react";
import ImageCard from "../../../Components/ImageCard"
import { Col, Row } from "react-bootstrap"

const NewsList = (props) => {
    return (
        <Row>
            {props.news.map( article => {
                // render only if news type is in whitelist
                if (props.whitelist.includes(article.type)) {
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
                }
            })}
        </Row>
    );
}

export default NewsList;