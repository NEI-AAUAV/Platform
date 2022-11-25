import { Card,Text} from "@nextui-org/react"
import "../index.css";

const InfoTeamSection = () => {
    const columnsPerRow = 3;
    return (
    <div className="d-flex flex-wrap" style={{ justifyContent:"space-evenly"}}>
        <div className="column">
            <div className="row">
                <Card variant="bordered" className="rally-card-team-image">   
                    <Card.Image
                    src="https://nextui.org/images/card-example-2.jpeg"
                    width="350px"
                    height="100%"
                    objectFit="cover"
                    alt="Card image background"
                    />
                </Card>
            </div>
            <div className="row">
                <Card variant="bordered" className="rally-card-team-name" >
                    <Card.Body>
                        <Text style={{color:"#FC8551"}}>9th place</Text>
                        <Text h3 style={{color:"white"}}>Team Name</Text>
                    </Card.Body>
                </Card>
            </div>
        </div>
        <div className="column">
            <div className="row">
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
            </div>
            <div className="row">
                <Card variant="bordered" className="rally-card-team-checkpoint">
                    <Card.Body>
                        <Text h3 style={{color:"#FC8551",fontWeight:"bold"}}>{'>'} CHECKPOINT</Text>
                        <Text style={{color:"white"}}>Last Checkpoint</Text>
                        <Text style={{color:"white"}}>Score: <span style={{color:"red"}}>10ptx</span></Text>
                        <Text style={{color:"white"}}>Date: --/--/-- --:--</Text>
                    </Card.Body>
                </Card>
            </div>
        </div>
    </div>
    );
}

export default InfoTeamSection;
