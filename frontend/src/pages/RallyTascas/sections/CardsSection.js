import InfoTeamSection from "./InfoTeamSection";
import { Card, Col, Text } from "@nextui-org/react";
import React, { useState } from "react";

const Card2 = () => {
  const Images = [
    {
      title: "Lemon 2",
      img: "/images/fruit-6.jpeg",
      text: "$8.00",
    },
    {
      title: "Banana",
      img: "/images/fruit-7.jpeg",
      text: "$7.50",
    },
    {
      title: "Watermelon",
      img: "/images/fruit-8.jpeg",
      text: "$12.20",
    },
  ];
  const [visible, setVisible] = useState(false);


    return (
        <Card variant="bordered" isPressable onPress={() => {setVisible(visible)}} css={{ bg: "#FC855133"  /* os últimos dois números são do canal alfa, que mostra a opacidade só do background-color*/ , w: "30%", border: "2px solid #FC8551 !important", display: visible ? "none" : "block" }}>   
        <Card.Image
        src="https://nextui.org/images/card-example-2.jpeg"
        width="100%"
        height={340}
        objectFit="cover"
        alt="Card image background"
      />
      <Card.Footer css={{fontFamily: "Aldrich", zIndex: 1, paddingBottom: 0}}>
          <Col>
            <Text h3 color="#FC8551" >
              TITLE
            </Text>
          </Col>
        </Card.Footer> 
        <Card.Body /* visible={visible} setVisible={setVisible} */ css={{fontFamily: "Aldrich", zIndex: 1, paddingTop: 0}}> 
        <Text h4 color="#FFFFFF" >
              Esta carta é muito louca. Confia MANO!
            </Text>
        </Card.Body>
    </Card>
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
