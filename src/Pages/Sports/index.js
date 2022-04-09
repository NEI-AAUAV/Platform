import React, { useState, useEffect } from 'react'
import { Row, Spinner } from 'react-bootstrap';
import Image from 'react-bootstrap/Image';
import Carousel from 'react-bootstrap/Carousel';
import img1 from './unknown.png';
import img2 from './unknown2.png';
import img3 from './unknown3.png';

import Tabs from "../../Components/Tabs/index.js";

import Typist from 'react-typist';

import "./index.css";

const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);

const Sports = () => {

    const [tabIndicator, setTabIndicator] = useState("Andebol");

    function changeTab(value) {
        setTabIndicator(value);
    }

    return (
        <>
            <div className="d-flex flex-column flex-wrap">
                <h2 className="mb-5 text-center"><Typist>Taça UA</Typist></h2>
            </div>
            <div className='slideUpFade' style={{animationDelay: animationBase + animationIncrement}}>
            <Carousel fade>
                <Carousel.Item interval={2000}>
                    <div style={{height: "500px"}}>
                        <img
                            className="d-block w-100"
                            src={img1}
                            alt="Image One"
                            style={{height: "100%", objectFit: "cover"}}
                        />
                    </div>
                </Carousel.Item>
                <Carousel.Item interval={2000}>
                    <div style={{height: "500px"}}>
                        <img
                            className="d-block w-100"
                            src={img2}
                            alt="Image One"
                            style={{height: "100%", objectFit: "cover"}}
                        />
                    </div>
                </Carousel.Item>
                <Carousel.Item interval={2000}>
                    <div style={{height: "500px"}}>
                        <img
                            className="d-block w-100"
                            src={img3}
                            alt="Image One"
                            style={{height: "100%", objectFit: "cover"}}
                        />
                    </div>
                </Carousel.Item>
            </Carousel>
            </div>
            <div style={{marginTop: "50px"}}>
                <h3 className='mb-5 text-center slideUpFade'>Modalidades</h3>
            </div>
            <div class='lista'>
                <ul className='slideUpFade'>
                    {tabIndicator=="Andebol" ? <li class="act">Andebol</li> : <li onClick={() => changeTab("Andebol")}>Andebol</li>}
                    {tabIndicator=="Futebol" ? <li class="act">Futebol</li> : <li onClick={() => changeTab("Futebol")}>Futebol</li>}
                    {tabIndicator=="Voleibol" ? <li class="act">Voleibol</li> : <li onClick={() => changeTab("Voleibol")}>Voleibol</li>}
                    {tabIndicator=="Futsal" ? <li class="act">Futsal</li> : <li onClick={() => changeTab("Futsal")}>Futsal</li>}
                    {tabIndicator=="Basquetebol" ? <li class="act">Basquetebol</li> : <li onClick={() => changeTab("Basquetebol")}>Basquetebol</li>}
                </ul>
            </div>
        </>
    )

}

export default Sports;