import InfoTeamSection from "./InfoTeamSection";
import { Card, Col, Text } from "@nextui-org/react";
import { Button } from '@nextui-org/react';
import imagem from '../../Sports/img/equipa.jpg'



const TeamCard = () => {
  return (
    <div>

      <Card css={{ bg: "transparent", borderColor: "#FC8551", w: 300, marginBottom: 20 }}>
        <Card.Image
          src={imagem}
          width="100%"
          height={340}
          objectFit="cover"
          alt="Card image background"
        />
        <Card.Footer css={{ fontFamily: "Aldrich", zIndex: 1}}>
          <Col>
            <Text h3 color="#FFFFFF" css={{textAlign: 'center'}} >
              Team Name
            </Text>
            <Button
              auto
              css={{
                borderRadius: '$xs', // radii.xs
                border: '$space$1 solid transparent',
                background: '#FC8551', // colors.pink800
                color: 'black',
                fontSize:25,
                textAlign:"center",
                padding:5,
                width:"100%" ,
                borderRadius: '12px',
                boxShadow: '$md', // shadows.md
                '&:hover': {
                  background: '#FC8551bb',
                },
              }}
            >
              View Team
            </Button>
          </Col>

        </Card.Footer>
      </Card>



    </div>

  );
}


const TeamsSection = () => {
  return (
    <div className="d-flex flex-wrap" style={{ justifyContent: 'space-evenly'}}>

      <TeamCard />
      <TeamCard />
      <TeamCard />
      <TeamCard />
      <TeamCard />
      <TeamCard />
    </div>
  );
}

export default TeamsSection;
