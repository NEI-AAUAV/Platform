import React, { useEffect, useState } from "react";
import ImageCard from "../../Components/ImageCard"
import { Col, Row } from "react-bootstrap";
import Typist from 'react-typist';

const Partners = () => {

    const [partners, setPartners] = useState([]);
    const [banner, setBanner] = useState(undefined);

    // Get API data when component renders
    useEffect(() => {
        fetch(process.env.REACT_APP_API + "/partners")
            .then(response => response.json())
            .then((response) => {
                if('data' in response) {
                    setPartners(response['data']);
                }
            });
        // Get partner banner
        fetch(process.env.REACT_APP_API + "/partners/banner")
            .then(response => response.json())
            .then((response) => {
                if('data' in response && response.data.length) {
                    setBanner(response['data'][0]);
                }
            });
    }, []);

    return (
        <div>
            <h2 className="text-center mb-4"><Typist>Parceiros</Typist></h2>

            {
                banner && 
                <Col xs={12} className="my-3 p-0">
                    <a href={banner.bannerUrl} target="_blank">
                        <img 
                            src={process.env.REACT_APP_STATIC + banner.bannerImage}
                            className="w-100"
                        />
                        <p className="mb-0 text-primary text-center small">O NEI é apoiado pela {banner.company}</p>
                    </a>
                </Col>
            }
            
            <Row>
                {partners.map( partner => {
                    return(
                        <Col md={6}>
                            <ImageCard
                                image={partner.header && process.env.REACT_APP_STATIC + partner.header}
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