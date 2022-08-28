import React, { useEffect, useState } from "react";
import { Button, Row, Col } from "react-bootstrap";
import Image from 'react-bootstrap/Image';
import "./index.css";
import Typist from 'react-typist';


// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);


const Merchandising = () => {

    const [imgs, setImgs] = useState([]);

    useEffect(() => {
        fetch(process.env.REACT_APP_API + "/merch/")
            .then(response => response.json())
            .then((response) => {

                if ('data' in response) {
                    setImgs(response.data.map((img, idx) =>
                        <div
                            className={
                                idx % 2 == 0
                                    ? "impar text-center slideUpFade"
                                    : "par2 text-center slideUpFade"
                            }
                            style={{
                                animationDelay: animationBase + animationIncrement * idx + "s",
                            }}
                        >
                            <Row className="mx-0">
                                <Col lg={idx % 2 == 0 ? 4 : 8} md={6} sm={12} className={idx % 2 == 0 ? "order-0 d-flex" : "order-1 d-flex"}>
                                    {
                                        img.image
                                            ? <Image className="img my-auto mx-auto" src={process.env.REACT_APP_STATIC + img.image} style={{ width: 200 }} />
                                            : <p className="text-center mx-auto my-auto small">Imagem disponível em breve.</p>
                                    }
                                </Col>
                                <Col lg={idx % 2 == 0 ? 8 : 4} md={6} sm={12} className={idx % 2 == 0 ? "order-1" : "order-0"}>
                                    <h22>{img.name}</h22>
                                    <h55>Preço: {img.price}€</h55>
                                </Col>
                            </Row>

                        </div>
                    ));
                }
            })
    }, [])

    return (
        <div className="py-5">
            <h2 style={{ position: "relative" }} className="mb-5 text-center">
                <Typist>Merchandising</Typist>
            </h2>

            {imgs}

            <Row className="text-center mx-0" style={{ position: "relative" }}>
                <a
                    href="https://aauav.pt/nucleos/"
                    target="_blank"
                    className="mx-auto"
                >
                    <Button
                        variant="outline-primary"
                        className="rounded-pill btn-outline-primary-force"
                        size="lg"
                    >Comprar
                    </Button>
                </a>
            </Row>
        </div>
    );
}

export default Merchandising;