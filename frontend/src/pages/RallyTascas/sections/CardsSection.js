import { Card, Col, Text, Button, Loading } from "@nextui-org/react";
import React, { Fragment, useEffect, useState } from "react";
import service from 'services/RallyTascasService';
import { useRallyAuth } from "stores/useRallyAuth";
import { Dropdown } from "@nextui-org/react";
import "../index.css";


const images = [
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

const checkApplicable = (team, card) => {
  if (!team) return false;

  const checkpoint_id = team.times.length - 1;

  switch (card) {
    case 'card1':
      return !(team.card1 != 0 || team.question_scores[checkpoint_id])
    case 'card2':
      return !(team.card2 != 0 || team.skips[checkpoint_id] <= 0)
    case 'card3':
      return !(team.card3 != 0 || team.pukes[checkpoint_id] <= 0)
  }
  return false;
}

const Card2 = ({ item, index, team, reload }) => {

  const [loading, setLoading] = useState(false);
  const [textvisible, settextVisible] = useState(true);
  const { isStaff } = useRallyAuth(state => state);

  const disabled = team?.[`card${index + 1}`] !== 0;
  const applicable = checkApplicable(team, `card${index + 1}`);

  const updateCard = () => {
    setLoading(true);
    service.updateTeamCards(team.id, { [`card${index + 1}`]: true })
      .then(() => {
        reload();
        setLoading(false);
      })
  }

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

        <Card.Body css={{ fontFamily: "Akshar", zIndex: 1, paddingTop: 5, overflow: 'hidden' }}>
          {!disabled &&
            (isStaff ?
              <Button disabled={!applicable} rounded shadow color="rgb(252, 133, 81)"
                onPress={() => isStaff && applicable && updateCard()}
                css={{
                  backgroundColor: "rgb(252, 133, 81)",
                  margin: "auto",
                  height: '3rem',
                  fontSize: '1.1rem'
                }}
              >{loading ? <Loading color="currentColor" size="sm" /> : applicable ? 'Ativar' : 'Não aplicável'}</Button>
              :
              <Text h4 color="#FFFFFF" css={{ height: textvisible ? 0 : '175px', transition: 'height 0.2s linear', overflow: 'hidden' }}>
                {item.text}
              </Text>
            )
          }
        </Card.Body>
      </Card>
    </>
  );
}

const CardsSection = () => {

  const [team, setTeam] = useState(null);
  const [allTeams, setAllTeams] = useState([]);
  const { isStaff, isAdmin } = useRallyAuth(state => state);

  function fetchTeams() {
    service.getCheckpointTeams()
      .then((data) => {
        setAllTeams(data);
        setTeam(team ? data.find(t => t.id === team?.id) : data[0]);
      });
  }

  // Get API data when component renders
  useEffect(() => {
    if (isStaff || isAdmin) {
      fetchTeams();
    } else {
      service.getOwnTeam()
        .then((data) => setTeam(data));
    }
  }, []);

  return (
    <>
      {allTeams.length > 0 && team &&
        <Dropdown>
          <Dropdown.Button flat color="warning" css={{ tt: "capitalize", fontWeight: 'bold', marginLeft: 8 }}>
            {team.name}
          </Dropdown.Button>
          <Dropdown.Menu
            color="warning"
            aria-label="Teams selection"
            disallowEmptySelection
            selectionMode="single"
            selectedKeys={[0]}
            onSelectionChange={(k) => setTeam(allTeams[k.currentKey])}
            css={{ fontFamily: 'monospace' }}
          >
            {
              allTeams.map((team, index) =>
                <Dropdown.Item key={index} css={{ padding: '0.3rem 0', height: 'auto' }} textValue="none">
                  (<b>{(team.card1 === 0) + (team.card2 === 0) + (team.card3 === 0)}</b>)
                  {' '}{team.name}
                </Dropdown.Item>
              )
            }
          </Dropdown.Menu>
        </Dropdown>
      }
      {
        !!team ?
          <div className="d-flex flex-wrap" style={{ justifyContent: "space-evenly" }}>
            {images.map((item, index) => (
              team?.[`card${index + 1}`] !== -1 &&
              <Fragment key={index}>
                <Card2
                  item={item}
                  index={index}
                  team={team}
                  reload={fetchTeams}
                />
              </Fragment>
            ))}
            {((team?.card1 == -1 && team?.card2 == -1 && team?.card3 == -1) ?
              <div className="rally-cards-empty">
                <p>Não recebeste nenhuma carta.</p><p>Vai beber!</p>
              </div>
              :
              null
            )}
          </div>
          :
          <div className="rally-cards-empty">
            <p>Nenhuma equipa disponível.</p>
          </div>
      }

    </>
  );
}

export default CardsSection;
