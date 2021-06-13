import React, { useEffect, useState } from "react";
import ImageCard from "../../Components/ImageCard"
import { Col, Row } from "react-bootstrap";
import Typist from 'react-typist';

const Partners = () => {

    const [partners, setPartners] = useState([]);

    // Get API data when component renders
    useEffect(() => {
        fetch(process.env.REACT_APP_API + "/partners")
            .then(response => response.json())
            .then((response) => {
                if('data' in response) {
                    setPartners(response['data']);
                }
            });
    }, []);

    return (
        <div>
            <h2 className="text-center mb-4"><Typist>Parceiros</Typist></h2>
            
            <Row>
                {partners.map( partner => {
                    return(
                        <Col md={6}>
                            <ImageCard
                                image={process.env.REACT_APP_STATIC + partner.header}
                                title={partner.company}
                                text={partner.description}
                                anchor={partner.link}
                                darkMode="on"
                            ></ImageCard>
                        </Col>
                    );
                })}
            </Row>
        </div>
    );
}

export default Partners;