import { Card, Col, Text, Button } from "@nextui-org/react";
import React, { useEffect, useState } from "react";
import "../index.css";
import service from 'services/RallyTascasService';
import { useRallyAuth } from "stores/useRallyAuth";



const Card2 = ({ item, index, disabled }) => {

  const [textvisible, settextVisible] = useState(true);
  const { isStaff } = useRallyAuth(state => state);

  return (
    <>
      <Card key={index} variant="bordered" isPressable={!disabled} onPress={() => settextVisible(!textvisible)}
        css={{
          bg: "#FC855133"  /* os últimos dois números são do canal alfa, que mostra a opacidade só do background-color*/,
          w: "280px", h: 400,
          border: "2px solid #FC8551 !important",
          margin: 15, opacity: disabled ? 0.5 : 1,
          filter: disabled ? "grayscale(80%)" : 'none',
        }}>
        <div style={{ backgroundColor: "#1D1D1D", backgroundImage: `url(${item.img})`, backgroundPosition: 'center', backgroundRepeat: 'no-repeat', height: '100%' }}>
        </div>
        <Card.Footer css={{ fontFamily: "Akshar", zIndex: 1, paddingBottom: 0 }}>
          <Col>
            <Text h3 color="#FC8551" >
              {item.title}
            </Text>
          </Col>
        </Card.Footer>

        <Card.Body css={{ fontFamily: "Akshar", zIndex: 1, paddingTop: 0, overflow: 'hidden' }}>
          {isStaff ?
            <Button rounded shadow color="rgb(252, 133, 81)" css={{
              backgroundColor: "rgb(252, 133, 81)",
              margin: "auto",
              '&:hover': {

              },
              '& span': {
              }
            }}>Default</Button>
            :
            <Text h4 color="#FFFFFF" css={{ height: textvisible ? 0 : '175px', transition: 'height 0.2s linear', overflow: 'hidden' }}>
              {item.text}
            </Text>
          }
        </Card.Body>
      </Card>
    </>
  );
}

const CardsSection = () => {
  const Images = [
    {
      title: "Pergunta-Pass❔",
      img: "../images/CardsSection/CABULA_CABULOSA.svg",
      text: "Poupa alguns neurónios! Tens direito a passar uma pergunta à frente, no entanto, recebes 6 pontos, em vez de 8.",
    },
    {
      title: "Desafio-pass🎯",
      img: "../images/CardsSection/SKIP_GYM_DAY.svg",
      text: "Tens direito a passar um desafio à frente, no entanto, recebes 8 pontos em vez de 10.",
    },
    {
      title: "Grego-Pass🤮",
      img: "../images/CardsSection/CHAMAR_O_GREGORIO.svg",
      text: "Deita tudo cá para fora! Um dos elementos tem direito a vomitar uma vez.",
    },
  ];
  const [Team, setTeam] = useState([]);
  // Get API data when component renders
  useEffect(() => {
    service.getOwnTeam()
      .then((data) => {
        setTeam(data);
      });
  }, []);

  return (
    <div className="d-flex flex-wrap" style={{ justifyContent: "space-evenly" }}>
      {Images.map((item, index) => (
        Team?.[`card${index + 1}`] !== -1 && <Card2 key={index} item={item} index={index} disabled={Team?.[`card${index + 1}`] !== 0} />
      ))}
      {((Team.card1 == -1 && Team.card2 == -1 && Team.card3 == -1) ?
        <div className="rally-cards-empty">
          <p>Não tens nenhuma carta.</p><p>Vai beber!</p>
        </div>
        :
        null
      )}
    </div>
  );
}

export default CardsSection;
