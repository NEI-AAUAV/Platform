import { Card, Grid, Text} from "@nextui-org/react"
import "../index.css";

const InfoTeamSection = () => {
    return (
        <Grid.Container gap={2}>
            <Grid xs={4}>
                <Card className="rally-card-team-name">
                    <Card.Body>
                        <Text h3 style={{color:"white"}}>Team 1</Text>
                    </Card.Body>
                </Card>
            </Grid>
        </Grid.Container>
    )
}

export default InfoTeamSection;
