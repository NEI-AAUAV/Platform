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

       setImgs(arr.map((img,idx) => 
            <div>
                {idx%2 == 0 ?
                <div style={{textAlign:"right"}} className="impar">
                    <Row>
                        <Image col={6} src={img.url}  style={{width: 200}}/>
                        <Col col={6}>
                            <h2>{img.name}</h2>
                            <h5>Preço: {img.preco}€ Portes: {img.portes}€</h5>
                            <h3 style={{paddingTop: '2em'}}>
                                {
                                    img.disponivel ? "Disponível" : "Indisponível"
                                }
                            </h3> 
                        </Col>
                    </Row>
                    
                </div>
                :
                <div style={{textAlign:"left"}} className="par2">
                    <Row>
                        <Col col={6} >
                            <h2>{img.name}</h2>
                            <h5>Preço: {img.preco}€ Portes: {img.portes}€</h5>
                            <h3 style={{paddingTop: '2em'}}>
                                {
                                    img.disponivel ? "Disponível" : "Indisponível"
                                }
                            </h3> 
                        </Col>
                        <Image col={6} src={img.url}  style={{width: 200}}/>
                    </Row>
                </div>
                }
                <Button style={{position: "relative"}}
                        variant="outline-dark"
                        className="rounded-pill mx-auto"
                        size="lg"
                        href="https://aauav.pt/nucleos/"
                        >Ver Todas
                </Button>
            </div>
           
       ));


    }, [])

    return (
        <div>
            <h2 style={{position:"relative"}} className="mb-5 text-center">Merchandising</h2>

           {imgs}

        </div>
    ); 
}

export default Merchandising;