import InfoTeamSection from "./InfoTeamSection";
import { Card, Col, Text } from "@nextui-org/react";
import { Button } from '@nextui-org/react';
import React, { useState } from "react";



const TeamCard = () => {
  const images = [
    {
      img: './images/IconsTeamsSection/icon1.png',
    },
    {
      img: "./images/IconsTeamsSection/icon2.png",
    },
    {
      img: "./images/IconsTeamsSection/icon3.png",
    },
    {
      img: "./images/IconsTeamsSection/icon4.png",
    },
    {
      img: "./images/IconsTeamsSection/icon5.png",
    },
    {
      img: "./images/IconsTeamsSection/icon6.png",
    },
    {
      img: "./images/IconsTeamsSection/icon7.png",
    },
    {
      img: "./images/IconsTeamsSection/icon8.png",
    },
    {
      img: "./images/IconsTeamsSection/icon9.png",
    },
    {
      img: "./images/IconsTeamsSection/icon10.png",
    },
    {
      img: "./images/IconsTeamsSection/icon11.png",
    },
    {
      img: "./images/IconsTeamsSection/icon12.png",
    },
    {
      img: "./images/IconsTeamsSection/icon13.png",
    },
    {
      img: "./images/IconsTeamsSection/icon14.png",
    },
    {
      img: "./images/IconsTeamsSection/icon15.png",
    },
    {
      img: "./images/IconsTeamsSection/icon16.png",
    },
  ];

  const [show, setShow] = useState(false);

  if (show)
  return (
    <InfoTeamSection />
  );

  return (
    <>
      {images.map((item, index) => (
        <Card key={index} css={{ bg: "transparent", borderColor: "#FC8551", w: 300, marginBottom: 20 }}>

          <Card.Image
            src={item.img}
            height="50%"
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

                onPress={() => {setShow(true)}}
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
    <div className="d-flex flex-wrap" style={{ justifyContent: 'space-evenly' }}>
      <TeamCard />
    </div>
  );
}

export default TeamsSection;
