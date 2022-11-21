import InfoTeamSection from "./InfoTeamSection";
import { Card, Col, Text } from "@nextui-org/react";
import { css, Button } from '@nextui-org/react';



const TeamCard = () => {
  return (
    <>

      <Card css={{ w: "100%" }}>
        <Card.Header css={{ position: "absolute", zIndex: 1, top: 5 }}>
          <Col>
            <Text size={12} weight="bold" transform="uppercase" color="#ffffffAA">
              Plant a tree
            </Text>
            <Text h4 color="white">
              Contribute to the planet
            </Text>
          </Col>
        </Card.Header>
        <Card.Image
          src="https://nextui.org/images/card-example-3.jpeg"
          width="100%"
          height={340}
          objectFit="cover"
          alt="Card image background"
        />
      </Card>
      <Button
        auto
        css={{
          borderRadius: '$xs', // radii.xs
          border: '$space$1 solid transparent',
          background: '$orange800', // colors.pink800
          color: '$orange100',
          height: '$12', // space[12]
          boxShadow: '$md', // shadows.md
          '&:hover': {
            background: '$orange100',
            color: '$orange800',
          },
          '&:active': {
            background: '$orange200',
          },
          '&:focus': {
            borderColor: '$orange400',
          },
        }}
      >
        Custom button
      </Button>
    </>

  );
}


const TeamsSection = () => {
  return (
    <>
      <TeamCard />
    </>
  );
}

export default TeamsSection;
