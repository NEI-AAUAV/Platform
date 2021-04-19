import React from "react";
import ImageCard from "../../../Components/ImageCard"
import { Col, Row } from "react-bootstrap"

const NewsList = (props) => {
    var key = 1;

    return (
        <Row>
            {props.news.map( article => {
                return(
                    <Col lg={4} md={6} sm={12} key={key++}>
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
            })}
        </Row>
    );
}

export default NewsList;