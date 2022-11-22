import { Card, Grid, Text} from "@nextui-org/react"
import "../index.css";

const InfoTeamSection = () => {
    return (
        <Grid.Container gap={2}>
            <Grid xs={4}>
                <Card className="rally-card-team-name">
                    <Card.Body>
                        <Text style={{color:"#FC8551"}}>9th place</Text>
                        <Text h3 style={{color:"white"}}>Team Name</Text>
                    </Card.Body>
                </Card>
            </Grid>
            <Grid xs={4}>
                <Card className="rally-card-team-information">
                    <Card.Body>
                        <Text h3 style={{color:"#FC8551",fontWeight:"bold"}}>{'>'} TEAM MEMBERS</Text>
                        <Text style={{color:"white"}}>Team Member 1</Text>
                        <Text style={{color:"white"}}>Team Member 2</Text>
                        <Text style={{color:"white"}}>Team Member 3</Text>
                        <Text style={{color:"white"}}>Team Member 4</Text>
                        <Text style={{color:"white"}}>Team Member 5</Text>
                    </Card.Body>
                </Card>
            </Grid>
            <Grid xs={4}>
                <Card className="rally-card-team-checkpoint">
                    <Card.Body>
                        <Text h3 style={{color:"#FC8551",fontWeight:"bold"}}>{'>'} CHECKPOINT</Text>
                        <Text style={{color:"white"}}>Last Checkpoint</Text>
                        <Text style={{color:"white"}}>Score: <span style={{color:"red"}}>10ptx</span></Text>
                        <Text style={{color:"white"}}>Date: --/--/-- --:--</Text>
                    </Card.Body>
                </Card>
            </Grid>
        </Grid.Container>
    )
}

export default InfoTeamSection;
