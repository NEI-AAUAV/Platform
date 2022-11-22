import InfoTeamSection from "./InfoTeamSection";
import { Card, Col, Text } from "@nextui-org/react";
import { Button } from '@nextui-org/react';
import icon1 from './IconsTeamsSection/icon1.png';



const TeamCard = () => {
  const list = [
    {
      img: "../img/icon1.png",
    },
    {
      img: "../img/icon2.png",
    },
    {
      img: "../img/icon3.png",
    },
    {
      img: "../img/icon4.png",
    },
    {
      img: "../img/icon5.png",
    },
    {
      img: "../img/icon6.png",
    },
    {
      img: "../img/icon1.png",
    },
    {
      img: "../img/icon1.png",
    },
  ];

  return (
    <div>
      {list.map((item, index) => (
        <Card key={index} css={{ bg: "transparent", borderColor: "#FC8551", w: 300, marginBottom: 20 }}>

          <Card.Image
            src={item.img}
            width="100%"
            objectFit="contain"
            alt="Card image background"
          />
          <Card.Footer css={{ fontFamily: "Aldrich", zIndex: 1 }}>
            <Col>
              <Text h3 color="#FFFFFF" css={{ textAlign: 'center' }} >
                Team Name
              </Text>
              <Button
                auto
                css={{
                  borderRadius: '$xs', // radii.xs
                  border: '$space$1 solid transparent',
                  background: '#FC8551', // colors.pink800
                  color: 'black',
                  fontSize: 25,
                  textAlign: "center",
                  padding: 5,
                  width: "100%",
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


      ))}
    </div>

  );
}


const TeamsSection = () => {
  return (
    <div className="d-flex flex-wrap" style={{ justifyContent: 'space-evenly' }}>
      <TeamCard />
    </div>
  );
}

export default TeamsSection;
