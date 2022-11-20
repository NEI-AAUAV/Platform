import { Button, Col, Row } from "@nextui-org/react";
import React, { useState } from "react";
import ModalTeam from "./components/NewTeam/ModalTeam";
import ScoresSection from "./sections/ScoresSection";
import MapSection from "./sections/MapSection";
import CardsSection from "./sections/CardsSection";
import TeamsSection from "./sections/MapSection";
import { TabButton } from "./components/Customized";

import ClearIcon from "@nextui-org/react/esm/utils/clear-icon"

import { useNavigate } from "react-router";

import logo from 'assets/images/logo.png';
import bg from 'assets/images/rally_bg.jpg';
import './index.css';

// orange FC8551

const TAB = {
  SCORES: 0,
  MAP: 1,
  TEAMS: 2,
  CARDS: 3
}



const RallyTascas = () => {
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState(TAB.SCORES);
  const [visible, setVisible] = useState(false);
  const teamModalHandler = () => setVisible(true);


  return (
    <>
      <div style={{
        backgroundColor: "#00020E",
        backgroundImage: `url(${bg})`,
        backgroundPosition: 'center 100px',
        backgroundRepeat: 'repeat-x',
        backgroundSize: '1500px 100%',
        width: '100vw', height: '100vh',
        position: 'absolute', top: 0, left: 0,
        zIndex: -1
      }}>
      </div>
      <Col style={{ maxWidth: "1000px", margin: "0 auto", fontFamily: "", padding: '2rem 0.5rem' }}>
        <ClearIcon className="rally-close" fill="white" plain size="1.8rem" onClick={() => navigate('/')} />
        <h2 className="rally-header mt-3">Break the Bars</h2>
        <div className="d-flex flex-wrap justify-content-around mb-3">
          <TabButton active={activeTab === TAB.SCORES} onPress={() => setActiveTab(TAB.SCORES)} size="sm">Scores</TabButton>
          <TabButton active={activeTab === TAB.MAP} onPress={() => setActiveTab(TAB.MAP)} size="sm">Map</TabButton>
          <TabButton active={activeTab === TAB.TEAMS} onPress={() => setActiveTab(TAB.TEAMS)} size="sm">Teams</TabButton>
          <TabButton active={activeTab === TAB.CARDS} onPress={() => setActiveTab(TAB.CARDS)} size="sm">Cards</TabButton>
        </div>
        {
          activeTab === TAB.SCORES &&
          <>
            <Row
              css={{
                display: "flex",
                flexDirection: "row",
                justifyContent: "flex-end",
                marginBottom: "1rem",
                paddingRight: "0.5rem",
                zIndex: 1,
              }}
            >
              <Button
                css={{
                  marginRight: "0.5rem",
                }}
                shadow
                color="primary"
                auto
              >
                Ver Mapa
              </Button>
              <Button shadow color="secondary" auto onClick={teamModalHandler}>
                Criar Equipa
              </Button>
              <ModalTeam visible={visible} setVisible={setVisible} />
            </Row>
            <ScoresSection />
          </>
        }
        {
          activeTab === TAB.MAP &&
          <MapSection />
        }
        {
          activeTab === TAB.TEAMS &&
          <TeamsSection />
        }
        {
          activeTab === TAB.CARDS &&
          <CardsSection />
        }
      </Col>
    </>
  );
};

export default RallyTascas;
