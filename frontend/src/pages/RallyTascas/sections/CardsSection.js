import InfoTeamSection from "./InfoTeamSection";
import { Card, Col, Text } from "@nextui-org/react";
import React, { useState } from "react";
import "../index.css";

const Card2 = ({item, index}) => {
  
  const [visible, setVisible] = useState(true);


    return (
      <>  
        
        <Card key={index} variant="bordered" isPressable onPress={() => {setVisible(!visible)}} css={{ bg: "#FC855133"  /* os últimos dois números são do canal alfa, que mostra a opacidade só do background-color*/ , w: "280px",h: 400, border: "2px solid #FC8551 !important", margin: 15 }}>   
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
        {item.text}
            </Text>
        </Card.Body>
    </Card>
    </>
    );
}

const CardsSection = () => {
  const Images = [
    {
      title: "Lemon 2",
      img: "./images/merch/brasao.png",
      text: "Carta BACANA",
    },
    {
      title: "Banana",
      img: "./images/merch/brasao.png",
      text: "Louca Carta",
    },
    {
      title: "Watermelon",
      img: "./images/merch/brasao.png",
      text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed et nulla orci. Donec nec felis semper, cursus risus quis, fringilla nisi. Nulla imperdiet nibh a mi posuere lacinia in ut.",
    },
  ];

    return (
        <div className="d-flex flex-wrap" style={{ justifyContent:"space-evenly"}}>
         {Images.map((item, index) => (
            <Card2 item={item} index={index} />
    ))}

        </div>
    );
}

export default CardsSection;
