import React, { useEffect, useState } from "react";
import ImageCard from "components/ImageCard"
import { Col, Row } from "react-bootstrap";
import Typist from 'react-typist';

import service from 'services/NEIService';


const Partners = () => {

    const [partners, setPartners] = useState([]);
    const [banner, setBanner] = useState(undefined);

    // Get API data when component renders
    useEffect(() => {
        service.getPartners()
            .then((data) => {
                setPartners(data);
            });
        // Get partner banner
        service.getPartnersBanner()
            .then((data) => {
                setBanner(data);
            });
    }, []);

    return (
        <div>
            <h2 className="text-center mb-4"><Typist>Parceiros</Typist></h2>

            {
                !!banner &&
                <Col xs={12} className="my-3 p-0">
                    <a href={banner.banner_url} target="_blank">
                        <img
                            src={banner.banner_image}
                            className="w-100"
                        />
                        <p className="mb-0 text-primary text-center small">O NEI é apoiado pela {banner.company}</p>
                    </a>
                </Col>
            }

            <Row>
                {partners.map((partner, index) => {
                    return (
                        <Col md={6} key={index}>
                            <ImageCard
                                image={partner.header && partner.header}
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