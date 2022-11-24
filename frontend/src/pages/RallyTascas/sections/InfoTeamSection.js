import { Card, Grid,Text} from "@nextui-org/react"
import "../index.css";

const InfoTeamSection = () => {
    return (
        <div className="d-flex flex-wrap" style={{ justifyContent:"space-evenly"}}>
        <Grid.Container gap={2} >
            <Grid xs={4} css={{ paddingLeft:0,paddingRight:0}}>
            <Card variant="bordered" className="rally-card-team-image">   
        <Card.Image
        src="https://nextui.org/images/card-example-2.jpeg"
        width="100%"
        height="100%"
        objectFit="cover"
        alt="Card image background"
      />
    </Card>
            </Grid>
            <Grid xs={4}>
                <Card variant="bordered" className="rally-card-team-name" >
                    <Card.Body>
                        <Text style={{color:"#FC8551"}}>9th place</Text>
                        <Text h3 style={{color:"white"}}>Team Name</Text>
                    </Card.Body>
                </Card>
            </Grid>
            <Grid xs={4}>
                <Card className="rally-card-team-information" >
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
                <Card variant="bordered" className="rally-card-team-checkpoint">
                    <Card.Body>
                        <Text h3 style={{color:"#FC8551",fontWeight:"bold"}}>{'>'} CHECKPOINT</Text>
                        <Text style={{color:"white"}}>Last Checkpoint</Text>
                        <Text style={{color:"white"}}>Score: <span style={{color:"red"}}>10ptx</span></Text>
                        <Text style={{color:"white"}}>Date: --/--/-- --:--</Text>
                    </Card.Body>
                </Card>
            </Grid>
        </Grid.Container>
        </div>
    );
}

export default InfoTeamSection;
