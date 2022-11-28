import { Card, Col, Text } from "@nextui-org/react";
import React, { useEffect,useState } from "react";
import "../index.css";
import service from 'services/RallyTascasService';
import { useRallyAuth } from "stores/useRallyAuth";

const {isStaff, isAdmin } = useRallyAuth(state => state);

const Card2 = ({item, index,disabled}) => {
  
  const [textvisible, settextVisible] = useState(true);

    return (
      <>      
        <Card key={index} variant="bordered" isPressable onPress={() => {settextVisible(!textvisible)}} css={{ bg: "#FC855133"  /* os últimos dois números são do canal alfa, que mostra a opacidade só do background-color*/ , w: "280px",h: 400, border: "2px solid #FC8551 !important", margin: 15,opacity:disabled ? 0.5:1 }}>   
        <Card.Image
        src={item.img}
        css={{w:"3000px",objectFit: "fill",autoResize: true }}
        // falta colocar a imagem a dar resize para a full Width
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
        <Text h4 color="#FFFFFF" css={{height: textvisible ? 0 : '175px', transition: 'height 0.2s linear', overflow: 'hidden'}}>
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
      title: "Pergunta-Pass❔",
      img: "./images/CardsSection/CABULA CABULOSA.svg",
      text: "Poupa alguns neurónios! Tens direito a passar uma pergunta à frente, no entanto, recebes 6 pontos, em vez de 8",
    },
    {
      title: "Desafio-pass🎯",
      img: "./images/CardsSection/SKIP GYM DAY.svg",
      text: "Tens direito a passar um desafio à frente, no entanto, recebes 8 pontos em vez de 10",
    },
    {
      title: "Grego-Pass🤮",
      img: "./images/CardsSection/CHAMAR O GREGORIO.svg",
      text: "Deita tudo cá para fora! Um dos elementos tem direito a vomitar uma vez.",
    },
  ];
  const [Team, setTeam] = useState({
    "name": "A miha equipa bonita",
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
    "card1": -1,
    "card2": 0,
    "card3": 1
  });
      // Get API data when component renders
       /*
      useEffect(() => {
        service.getOwnTeam()
            .then((data) => {
                setTeam(data);
            });
    }, []);  */
 
    return (
        <div className="d-flex flex-wrap" style={{ justifyContent:"space-evenly"}}>
         {Images.map((item, index) => (
            Team?.[`card${index+1}`] !== -1 && <Card2 item={item} index={index} disabled={Team?.[`card${index+1}`] !== 0} />
    ))}
      {((Team.card1 ==-1 && Team.card2 ==-1  && Team.card3 ==-1 ) ?
    <text style={{ fontFamily:"Akshar",color:"white", fontSize:"60px",textAlign:"center",marginTop:"3rem",fontWeight: "bold"}}><p style={{all: "inherit"}}>Não tens nenhuma carta. Vai beber!</p></text>
    :
    null
    )}
      </div>
    );
}

export default CardsSection;
