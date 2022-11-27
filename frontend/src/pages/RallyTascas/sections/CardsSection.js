import { Card, Col, Text } from "@nextui-org/react";
import React, { useEffect,useState } from "react";
import "../index.css";
import service from 'services/RallyTascasService';

const Card2 = ({item, index}) => {
  
  const [textvisible, settextVisible] = useState(true);

    return (
      <>      
        <Card key={index} variant="bordered" isPressable onPress={() => {settextVisible(!textvisible)}} css={{ bg: "#FC855133"  /* os últimos dois números são do canal alfa, que mostra a opacidade só do background-color*/ , w: "280px",h: 400, border: "2px solid #FC8551 !important", margin: 15 }}>   
        <Card.Image
        src={item.img}
        width="100%"
        height="100%"
        objectFit="cover"
        alt="Card image background"
      />
      <Card.Footer css={{fontFamily: "Akshar", zIndex: 1, paddingBottom: 0}}>
          <Col>
            <Text h3 color="#FC8551" >
            {item.title}
            </Text>
          </Col>
        </Card.Footer> 
        <Card.Body css={{fontFamily: "Akshar", zIndex: 1, paddingTop: 0,  overflow: 'hidden'}}> 
        <Text h4 color="#FFFFFF" css={{height: textvisible ? 0 : '200px', transition: 'height 0.2s linear', overflow: 'hidden'}}>
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
  const [Team, setTeam] = useState({  "name": "A miha equipa bonita",
  "id": 0,
  "scores": [
    0
  ],
  "times": [
    "2022-11-27T16:16:03.903Z"
  ],
  "classification": 1,
  "members": [
    {
      "team_id": 0,
      "name": "Leandro Silva",
      "id": 0 
    }
  ],
  "card1": true,
  "card2": false,
  "card3": true});
      // Get API data when component renders
      useEffect(() => {
        service.getOwnTeam()
            .then((data) => {
                setTeam(data);
            });
    }, []);
 
    return (
        <div className="d-flex flex-wrap" style={{ justifyContent:"space-evenly"}}>
         {Images.map((item, index) => (
            Team[`card${index}`] && <Card2 item={item} index={index} />
    ))}
      {(!(Team.card1 || Team.card2 || Team.card3) ?
    <text style={{ fontFamily:"Akshar",color:"white", fontSize:"60px",textAlign:"center",marginTop:"3rem",fontWeight: "bold"}}><p style={{all: "inherit"}}>Não tens nenhuma carta. Vai beber!</p></text>
    :
    null
    )}
    
      </div>
    );
}

export default CardsSection;
