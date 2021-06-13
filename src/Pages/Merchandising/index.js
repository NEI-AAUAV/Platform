import React, { useEffect, useState } from "react";
import { fs } from "fs";
import { Button, Row, Col, Container } from "react-bootstrap";
import Image from 'react-bootstrap/Image';
import "./index.css";
import Typist from 'react-typist';


// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);


const Merchandising = () => {

    const [imgs, setImgs] = useState([]);

    useEffect(() => {
        fetch(process.env.REACT_APP_API + "/merch")
            .then(response => response.json())
            .then((response) => {

                if ('data' in response) {
                    setImgs(response.data.map((img, idx) =>
                        <div>
                            {idx % 2 == 0 ?
                                <div 
                                    className="impar text-center slideUpFade"
                                    style={{
                                        animationDelay: animationBase + animationIncrement*idx + "s",
                                    }}
                                >
                                    <Row className="mx-0">
                                        <Col lg={4} md={6} sm={12}>
                                            <Image className="img justify-content-center" src={img.image} style={{ width: 200 }} />
                                        </Col>
                                        <Col lg={8} md={6} sm={12}>
                                            <h2>{img.name}</h2>
                                            <h5>Preço: {img.price}€</h5>
                                            {/*
                                        <h3 style={{paddingTop: '2em'}}>
                                        {
                                            img.disponivel ? "Disponível" : "Indisponível"
                                        }
                                    </h3> 
                                    */
                                            }

                                        </Col>
                                    </Row>

                                </div>
                                :
                                <div
                                    className="par2 text-center slideUpFade"
                                    style={{
                                        animationDelay: animationBase + animationIncrement*idx + "s",
                                    }}
                                >
                                    <Row className="mx-0">
                                        <Col lg={4} md={6} sm={12} >
                                            <h2>{img.name}</h2>
                                            <h5>Preço: {img.price}€</h5>
                                            {/*
                                        <h3 style={{paddingTop: '2em'}}>
                                        {
                                            img.disponivel ? "Disponível" : "Indisponível"
                                        }
                                    </h3> 
                                    */
                                            }
                                        </Col>
                                        <Col lg={8} md={6} sm={12}>
                                            <Image className="img" src={img.image} style={{ width: 200 }} />
                                        </Col>

                                    </Row>
                                </div>
                            }
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
                    <Button style={{ color: 'black' }}
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