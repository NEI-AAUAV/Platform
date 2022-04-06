import React, { useState, useEffect } from 'react'
import { Row, Spinner } from 'react-bootstrap';
import Image from 'react-bootstrap/Image';
import Carousel from 'react-bootstrap/Carousel';
import img1 from './unknown.png';
import img2 from './unknown2.png';
import img3 from './unknown3.png';

import Tabs from "../../Components/Tabs/index.js";

import Typist from 'react-typist';

const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);

const Sports = () => {

    const [anos, setAnos] = useState([]);


    return (
        <>
            <div className="d-flex flex-column flex-wrap">
                <h2 className="mb-5 text-center"><Typist>Taça UA</Typist></h2>
            </div>
            <div className='slideUpFade' style={{animationDelay: animationBase + animationIncrement}}>
            <Carousel fade>
                <Carousel.Item interval={500}>
                    <div style={{height: "500px"}}>
                        <img
                            className="d-block w-100"
                            src={img1}
                            alt="Image One"
                            style={{height: "100%", objectFit: "cover"}}
                        />
                    </div>
                </Carousel.Item>
                <Carousel.Item interval={500}>
                    <div style={{height: "500px"}}>
                        <img
                            className="d-block w-100"
                            src={img2}
                            alt="Image One"
                            style={{height: "100%", objectFit: "cover"}}
                        />
                    </div>
                </Carousel.Item>
                <Carousel.Item interval={500}>
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
        </>
    )

}

export default Sports;