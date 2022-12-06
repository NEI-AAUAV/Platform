import React, { useState, useEffect } from "react";
import { useNavigate, Outlet, Navigate, useMatch, useResolvedPath } from "react-router";
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
  SCORES: "",
  MAP: "map",
  TEAMS: "teams",
  CARDS: "cards",
  LOGIN: "login",
}

const ProtectedRoute = ({ children, noAuth, participantOnly }) => {
  const { token, isStaff, isAdmin } = useRallyAuth(state => state);

  if ((noAuth ^ !token) || (participantOnly && (isStaff || isAdmin))) {
    return <Navigate to=".." replace />;
  }

  return children;
}

const rallyTascasRoutes = [
  { path: TAB.SCORES, element: <ScoresSection /> },
  { path: TAB.MAP, element: <ProtectedRoute participantOnly><MapSection /></ProtectedRoute> },
  { path: TAB.TEAMS, element: <TeamsSection /> },
  { path: TAB.CARDS, element: <ProtectedRoute><CardsSection /></ProtectedRoute> },
  { path: TAB.LOGIN, element: <ProtectedRoute noAuth><LoginSection /></ProtectedRoute> },
  { path: '*', element: <Navigate to="/breakthebars" replace /> },
];

const RallyTascas = () => {
  const navigate = useNavigate();

  const TabLink = ({ to, children }) => {
    const resolver = useResolvedPath(to);
    const match = useMatch({ path: resolver.pathname, end: true });

    return <TabButton active={match} onPress={() => navigate(to)} size="sm">{children}</TabButton>
  };

  const [visible, setVisible] = useState(false);
  const teamModalHandler = () => setVisible(true);
  const { ready, name, token, isStaff, isAdmin, teamName, logout } = useRallyAuth(state => state);
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
            !!mobile && !!ready &&
            <p className="rally-small-login m-0">
              {!token ?
                <span onClick={() => navigate(TAB.LOGIN)}>Log in</span>
                :
                <span onClick={() => { logout(); navigate(TAB.LOGIN) }}>Log out</span>
              }
              {!!name && <span className="name">&nbsp;{name}</span>}
            </p>
          }
          <ClearIcon className="rally-close" fill="white" plain size="1.8rem" onClick={() => navigate('/')} />
        </div>
        {
          !!ready ?
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
                        <TabButton active login onPress={() => navigate(TAB.LOGIN)} size="sm">Log in</TabButton>
                        :
                        <TabButton active login onPress={() => { logout(); navigate(TAB.LOGIN) }} size="sm">Log out</TabButton>
                    }
                  </div>
                }
              </div>
              <div className="d-flex flex-wrap justify-content-center justify-content-sm-start mb-3">
                <TabLink to={TAB.SCORES}>Scores</TabLink>
                <TabLink to={TAB.TEAMS}>Teams</TabLink>
                {
                  !!token &&
                  <TabLink to={TAB.CARDS}>Cards</TabLink>
                }
                {
                  !!token && !isStaff && !isAdmin &&
                  <TabLink to={TAB.MAP}>Map</TabLink>
                }
              </div>

              <Outlet />
            </>
            :
            <Countdown_section countdown_callback={()=>{useRallyAuth.getState().setReady()}}/>
        }
      </Col>
    </>
  );
};

export { RallyTascas, rallyTascasRoutes };
