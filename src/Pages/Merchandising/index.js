import React, { useEffect, useState } from "react";
import {fs} from "fs";
import { Button, Row, Col, Container } from "react-bootstrap";
import Image from 'react-bootstrap/Image';
import "./index.css";

const Merchandising = () => {

    const [imgs,setImgs] = useState([]);

    useEffect(() => {
        // Obter as imagens através da API (que ainda não temos)

        let arr = [
            {
                'name': 'Brasão',
                //'url': './public/images/merch/brasao.png',
                'url': "https://melmagazine.com/wp-content/uploads/2021/01/66f-1.jpg",
                'preco': 20.00,
                'portes': 2,
                'disponivel': true
            }, 
            {
                'name': 'Nei',
                'url': 'https://pop.inquirer.net/files/2021/05/834.png',
                'preco': 15.00,
                'portes': 3,
                'disponivel': true
            },
            {
                'name': 'Brasão2',
                'url': "https://pbs.twimg.com/media/EjUax6KXkAIWoN4.png",
                'preco': 19.99,
                'portes': 5,
                'disponivel': false
            },
        ];

        fetch(process.env.REACT_APP_API + "/merch")
        .then(response => response.json())
        .then((response) => {

            if ('data' in response) {
                setImgs(response.data.map((img,idx) => 
                    <div>
                        {idx%2 == 0 ?
                        <div className="impar text-center">
                            <Row className="mx-0">
                                <Col lg={4} md={6} sm={12}>
                                    <Image className="img justify-content-center"  src={img.image}  style={{width: 200}}/>
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
                        <div style={{/*textAlign:"left"*/}} className="par2 text-center">
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
                                    <Image className="img" src={img.image}  style={{width: 200}}/>
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
            <h2 style={{position:"relative"}} className="mb-5 text-center">Merchandising</h2>

           {imgs}
            <Row className="text-center mx-0" style={{position: "relative"}}>
                <Button     style={{color: 'black'}}
                            variant="outline-secondary"
                            className="rounded-pill mx-auto"
                            size="lg"
                            href="https://aauav.pt/nucleos/"
                            >Comprar
                </Button>
            </Row>
            

        </div>
    ); 
}

export default Merchandising;