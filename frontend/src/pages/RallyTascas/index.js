import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router";
import { Button, Col, Row } from "@nextui-org/react";
import ClearIcon from "@nextui-org/react/esm/utils/clear-icon"

import ModalTeam from "./components/NewTeam/ModalTeam";
import ScoresSection from "./sections/ScoresSection";
import MapSection from "./sections/MapSection";
import CardsSection from "./sections/CardsSection";
import TeamsSection from "./sections/TeamsSection";
import { Countdown_section } from "./sections/Countdown";
import Countdown from "./sections/Countdown";
import LoginSection from "./sections/LoginSection";
import { TabButton } from "./components/Customized";

import bg from "assets/images/rally_bg.jpg";
import "./index.css";
import { useRallyAuth } from "stores/useRallyAuth";


const TAB = {
  SCORES: 0,
  MAP: 1,
  TEAMS: 2,
  CARDS: 3,
  LOGIN: 4,
}

const RallyTascas = () => {
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState(TAB.SCORES);
  const [showCountdown, setShowCountdown] = useState(false);
  const [visible, setVisible] = useState(false);
  const teamModalHandler = () => setVisible(true);
  const { name, token, isStaff, isAdmin, teamName, logout } = useRallyAuth(state => state);
  const [mobile, setMobile] = useState(false);


  useEffect(() => {
    function handleResize() {
      setMobile(window.innerWidth < 650)
    }
    handleResize();
    window.addEventListener('resize', handleResize);
    return (() => {
      window.removeEventListener('resize', handleResize)
    });
  })


  return (
    <>
      <div
        className="flicker-bg"
        style={{
          backgroundColor: "#00020E",
          backgroundImage: `url(${bg})`,
          backgroundPosition: 'center 100px',
          backgroundRepeat: 'repeat-x',
          backgroundSize: '1500px 100vh',
          position: 'absolute', zIndex: -1,
          top: 0, left: 0, bottom: 0, right: 0,
        }}>
      </div>
      <Col style={{ maxWidth: "1000px", margin: "0 auto", fontFamily: "", padding: '2rem 0.5rem' }}>
        <div className="d-flex align-items-center">
          {
            !!mobile &&
            <p className="rally-small-login m-0">
              {!token ?
                <span onClick={() => setActiveTab(TAB.LOGIN)}>Log in</span>
                :
                <span onClick={() => { logout(); setActiveTab(TAB.LOGIN) }}>Log out</span>
              }
              {!!name && <span className="name">&nbsp;{name}</span>}
            </p>
          }
          <ClearIcon className="rally-close" fill="white" plain size="1.8rem" onClick={() => navigate('/')} />
        </div>
        {
          !showCountdown ?
            <>
              <div className="mt-3 d-flex flex-sm-row flex-column justify-content-between">
                <div>
                  {
                    isStaff ?
                      <h5 className="rally-small-header mt-3">Checkpoint #{isStaff}</h5>
                      :
                      teamName ?
                        <h5 className="rally-small-header mt-3">{teamName}</h5>
                        :
                        null
                  }
                  <h2 className="rally-header align-self-end">Break the Bars</h2>
                </div>
                {
                  !mobile &&
                  <div className="mb-3 d-flex flex-column align-items-end justify-content-center">
                    {!!token && <h5 className="rally-small-header mt-3 mr-3">{name}</h5>}
                    {
                      !token ?
                        <TabButton active login onPress={() => setActiveTab(TAB.LOGIN)} size="sm">Log in</TabButton>
                        :
                        <TabButton active login onPress={() => { logout(); setActiveTab(TAB.LOGIN) }} size="sm">Log out</TabButton>
                    }
                  </div>
                }
              </div>
              <div className="d-flex flex-wrap justify-content-center justify-content-sm-start mb-3">
                <TabButton active={activeTab === TAB.SCORES} onPress={() => setActiveTab(TAB.SCORES)} size="sm">Scores</TabButton>
                <TabButton active={activeTab === TAB.TEAMS} onPress={() => setActiveTab(TAB.TEAMS)} size="sm">Teams</TabButton>
                {
                  !!token && !isStaff && !isAdmin &&
                  <>
                    <TabButton active={activeTab === TAB.MAP} onPress={() => setActiveTab(TAB.MAP)} size="sm">Map</TabButton>
                    <TabButton active={activeTab === TAB.CARDS} onPress={() => setActiveTab(TAB.CARDS)} size="sm">Cards</TabButton>
                  </>
                }
              </div>
              {
                activeTab === TAB.SCORES &&
                <ScoresSection />
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
              {
                activeTab === TAB.LOGIN &&
                <LoginSection onSuccess={() => setActiveTab(TAB.SCORES)} />

              }
            </>
            :
            <Countdown_section />
        }
      </Col>
    </>
  );
};

export default RallyTascas;
