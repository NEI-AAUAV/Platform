import React from 'react';


import Image from 'react-bootstrap/Image';
import { Container, Col } from 'react-bootstrap';

import "./index.css";



const Player = () => {
    return (
        <div>
            { 
            <Col className="mx-auto" style={{ marginBottom: 40}}>
                <Image className={"imgTeam"} src={"https://i0.wp.com/techwek.com/wp-content/uploads/2020/12/Imagem-para-perfil.jpg?resize=512%2C473&ssl=1"} style={{ borderRadius:20, width: 200, marginBottom: 20}}/>
                <h3>Marco António</h3>
            </Col>
            }
        </div>
    )
}

export default Player;