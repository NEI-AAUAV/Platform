import InfoTeamSection from "./InfoTeamSection";
import { Card, Col, Text } from "@nextui-org/react";
import { Button } from '@nextui-org/react';



const TeamCard = () => {
  return (
    <div style={{height:500}}>

      <Card css={{ bg: "transparent", borderColor: "#FC8551", w: 300, margin:10 }}>
        <Card.Image
          src="https://nextui.org/images/card-example-2.jpeg"
          width="100%"
          height={400}
          objectFit="cover"
          alt="Card image background"
        />
        <Card.Footer css={{ fontFamily: "Aldrich", zIndex: 1, height:"100%" }}>
          <Col>
            <Text h3 color="#FC8551" >
              TITLE
            </Text>
            <Button
              auto
              css={{
                borderRadius: '$xs', // radii.xs
                border: '$space$1 solid transparent',
                background: '#FC8551', // colors.pink800
                color: 'white',
                height: '$12', // space[12]
                position: 'absolute',
                borderadius: '10px',
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
    <div className="d-flex flex-wrap">

      <TeamCard />
      <TeamCard />
      <TeamCard />
      <TeamCard />
      <TeamCard />
    </div>
  );
}

export default TeamsSection;
