import React from "react";
import ImageCard from "../../../Components/ImageCard"
import { Col, Row } from "react-bootstrap"

const NewsList = (props) => {
    return (
        <Row>
            {props.news.map( article => {
                // render only if news type is in whitelist
                if (props.whitelist.includes(article.category)) {
                    return(
                        <Col lg={4} md={6} sm={12}>
                            <ImageCard
                                //image={process.env.PUBLIC_URL + article.header}
                                image={"https://nei.web.ua.pt/" + article.header}
                                title={article.title}
                                preTitle={article.category}
                                text={article.created_at}
                                anchor="#" // TODO: use article.id here
                            ></ImageCard>
                        </Col>
                    );
                }
            })}
        </Row>
    );
}

export default NewsList;