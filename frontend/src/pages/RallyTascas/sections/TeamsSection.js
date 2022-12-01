import React, { useEffect, useState } from "react";
import InfoTeamSection from "./InfoTeamSection";
import { Card, Col, Text } from "@nextui-org/react";
import { Button } from '@nextui-org/react';
import service from 'services/RallyTascasService';


const TeamCard = () => {
  const [showTeam, setShowTeam] = useState(null);
  const [teams, setTeams] = useState([]);

  useEffect(() => {
    service.getTeams()
      .then((data) => setTeams(data));
  }, [])

  if (showTeam)
    return (
      <InfoTeamSection team={showTeam} />
    );

  return (
    <>
      {teams.map((team, index) => (
        <Card key={index} css={{ bg: "transparent", borderColor: "#FC8551", w: 150, marginBottom: 20, '@xs': { w: 200 } }}>

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
                  '&:hover': {
                    background: '#FC8551bb',
                  },
                }}
                onPress={() => { setShowTeam(team) }}
              >
                View Team
              </Button>
            </Col>
          </Card.Footer>
        </Card>
      ))}
    </>

  );
}


const TeamsSection = () => {
  return (
    <div className="d-flex flex-wrap mt-sm-5 mt-2" style={{ justifyContent: 'space-evenly' }}>
      <TeamCard />
    </div>
  );
}

export default TeamsSection;
