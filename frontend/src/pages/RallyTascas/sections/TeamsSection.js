import InfoTeamSection from "./InfoTeamSection";
import { Card, Col, Text } from "@nextui-org/react";

const TeamCard = () => {
    return (
        <>
          <Card css={{ bg: "$black", w: "100%" }}>
            <Card.Header css={{ position: "absolute", zIndex: 1, top: 5 }}>
              <Col>
                <Text h4 color="white" >
                  Team Name
                </Text>
              </Col>
            </Card.Header>    
            <Card.Image
            src="https://nextui.org/images/card-example-2.jpeg"
            width="100%"
            height={340}
            objectFit="cover"
            alt="Card image background"/>
        </Card>
        </>
    );
}


const TeamsSection = () => {
    if (true)
        return <InfoTeamSection />
    return (
        <>
            <TeamCard />
        </>
    );
}

export default TeamsSection;
