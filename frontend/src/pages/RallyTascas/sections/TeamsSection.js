import React, { useEffect, useState, Fragment } from "react";
import InfoTeamSection from "./InfoTeamSection";
import { Card, Col, Text } from "@nextui-org/react";
import { Button } from '@nextui-org/react';
import service from 'services/RallyTascasService';
import { useRallyAuth } from "stores/useRallyAuth";


const TeamCard = ({ team, showTeam, arriving }) => (
  <Card css={{ bg: "transparent", borderColor: "#FC8551", w: 150, marginBottom: 20, '@xs': { w: 200 } }}>
    <Card.Image
      src={`../images/IconsTeamsSection/icon${team.id % 16 + 1}.png`}
      css={{ h: 200 }}
      objectFit="contain"
      alt="Card image background"
    />
    <Card.Footer css={{ fontFamily: "Aldrich", zIndex: 1, flex: '1 0 auto', alignItems: 'flex-end', pt: 0 }}>
      <Col>
        <Text h4 color="#FFFFFF" css={{ textAlign: 'center' }} >
          {team.name}
        </Text>
        <Button
          auto
          className={arriving ? "glow-btn" : ""}
          css={{
            border: '$space$1 solid transparent',
            background: '#FC8551', // colors.pink800
            color: '#1d1d1d',
            fontSize: '1.1rem',
            height: '2.1rem',
            textAlign: "center",
            padding: 0,
            width: "100%",
            borderRadius: '12px',
            boxShadow: '$md', // shadows.md
            animation: arriving ? 'glowing 1300ms infinite' : null,
            '&:hover': {
              background: '#FC8551bb',
            },
          }}
          onPress={() => { showTeam(team) }}
        >
          {arriving ? "Team Arriving" : "View Team"}
        </Button>
      </Col>
    </Card.Footer>
  </Card>
);



const TeamsSection = () => {
  const [showTeam, setShowTeam] = useState(null);
  const [teams, setTeams] = useState([]);
  const { isStaff } = useRallyAuth(state => state);

  const fetchTeams = () => {
    service.getTeams()
      .then((data) =>
        setTeams(
          data.sort((a, b) => a.times.length - b.times.length)
            .sort((a, b) => Number(a.times.length === isStaff - 1))
        ));
  }

  useEffect(() => {
    fetchTeams();
    const intervalId = setInterval(fetchTeams, 30_000);
    return (() => {
        clearInterval(intervalId);
    });
  }, [])

  if (showTeam)
    return (
      <InfoTeamSection team={showTeam} goBack={() => setShowTeam(null)} />
    );

  return (
    <div className="d-flex flex-wrap mt-sm-5 mt-2" style={{ justifyContent: 'space-evenly' }}>
      {teams.map((team, index) => (
        <Fragment key={index}>
          <TeamCard team={team} showTeam={setShowTeam} arriving={team.times.length === isStaff - 1} />
        </Fragment>
      ))}
    </div>
  );
}

export default TeamsSection;
