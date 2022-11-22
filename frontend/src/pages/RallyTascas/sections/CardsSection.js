import InfoTeamSection from "./InfoTeamSection";
import { Card, Col, Text } from "@nextui-org/react";
import React, { useState } from "react";
import "../index.css";

const Card2 = () => {
  const Images = [
    {
      title: "Lemon 2",
      img: "./images/merch/brasao.png",
      text: "$8.00",
    },
    {
      title: "Banana",
      img: "./images/merch/brasao.png",
      text: "$7.50",
    },
    {
      title: "Watermelon",
      img: "./images/merch/brasao.png",
      text: "$12.20",
    },
  ];
  const [visible, setVisible] = useState(true);


    return (
      <>
         {Images.map((item, index) => (
        <Card key={index} variant="bordered" isPressable onPress={() => {setVisible(!visible)}} css={{ bg: "#FC855133"  /* os últimos dois números são do canal alfa, que mostra a opacidade só do background-color*/ , w: "30%",h: 450, border: "2px solid #FC8551 !important" }}>   
        <Card.Image
        src={item.img}
        width="100%"
        height="100%"
        objectFit="cover"
        alt="Card image background"
      />
      <Card.Footer css={{fontFamily: "Aldrich", zIndex: 1, paddingBottom: 0}}>
          <Col>
            <Text h3 color="#FC8551" >
            {item.title}
            </Text>
          </Col>
        </Card.Footer> 
        <Card.Body css={{fontFamily: "Aldrich", zIndex: 1, paddingTop: 0,  overflow: 'hidden'}}> 
        <Text h4 color="#FFFFFF" css={{height: visible ? 0 : '200px', transition: 'height 0.2s linear', overflow: 'hidden'}}>
        "Esta carta é muito louca. Confia MANO!"
            </Text>
        </Card.Body>
    </Card>
    ))}
    </>
    );
}

const CardsSection = () => {
    return (
        <>
            <Card2 />
        </>
    );
}

export default CardsSection;
