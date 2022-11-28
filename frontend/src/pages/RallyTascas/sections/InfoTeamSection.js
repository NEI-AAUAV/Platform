import { Card,Text} from "@nextui-org/react"
import "../index.css";

const InfoTeamSection = () => {
    const data = [
        {   
            team_image: "./images/IconsTeamsSection/icon1.png",
            team_name: "Team Name",
            team_elements: ["Team Member 1", "Team Member 2","Team Member 3","Team member 4","Team Member 5","Team Member 6"],
            checkpoint_points: 10,
            checkpoint_time: "--/--/-- --:--",
            total_score: 80
        }
    ]
    return (
        <>
            {data.map((item, index) => (
                <div key={index} className="d-flex flex-wrap" style={{ justifyContent:"space-evenly",fontFamily:"Aldrich"}}>
                    <div className="rally-tascas-column">
                        <div className="rally-tascas-row">
                            <Card variant="bordered" className="rally-card-team-image">   
                                <Card.Image
                                src={item.team_image}
                                width="350px"
                                height="100%"
                                objectFit="cover"
                                alt="Card image background"
                                />
                            </Card>
                        </div>
                        <div className="rally-tascas-row">
                            <Card variant="bordered" className="rally-card-team-name" >
                                <Card.Body>
                                    <Text style={{color:"#FC8551"}}>9th place</Text>
                                    <Text h3 style={{color:"white"}}>{item.team_name}</Text>
                                </Card.Body>
                            </Card>
                        </div>
                    </div>
                    <div className="rally-tascas-column">
                        <div className="rally-tascas-row">
                            <Card className="rally-card-team-information" >
                                <Card.Body>
                                    <Text h3 style={{color:"#FC8551",fontWeight:"bold"}}>{'>'} TEAM MEMBERS</Text>
                                    {/* <Text style={{color:"white"}}>Team Member 1</Text>
                                    <Text style={{color:"white"}}>Team Member 2</Text>
                                    <Text style={{color:"white"}}>Team Member 3</Text>
                                    <Text style={{color:"white"}}>Team Member 4</Text>
                                    <Text style={{color:"white"}}>Team Member 5</Text> */}
                                    <ol style={{paddingLeft:"0px"}}>
                                        {item.team_elements.map((element, index) => (
                                            <ul key={index} style={{color:"white",paddingLeft:"0px"}}>{element}</ul>
                                        ))}
                                    </ol>
                                </Card.Body>
                            </Card>
                        </div>
                        <div className="rally-tascas-row">
                            <Card variant="bordered" className="rally-card-team-checkpoint">
                                <Card.Body>
                                    <Text h3 style={{color:"#FC8551",fontWeight:"bold"}}>{'>'} CHECKPOINT</Text>
                                    <Text style={{color:"white"}}>Last Checkpoint</Text>
                                    <Text style={{color:"white"}}>Score: <span style={{color:"red"}}>{item.checkpoint_points} PTS</span></Text>
                                    <Text style={{color:"white"}}>Date: {item.checkpoint_time}</Text>
                                </Card.Body>
                            </Card>
                        </div>
                        <div className="rally-tascas-row">
                            <Card variant="bordered" className="rally-card-team-points">
                                <Card.Body>
                                    <Text h3 style={{color:"#FC8551",fontWeight:"bold"}}>{'>'} TOTAL SCORE</Text>
                                    <Text style={{color:"red"}}>{item.total_score} PTS</Text>
                                </Card.Body>
                            </Card>
                        </div>
                    </div>
                </div>
            ))}
        </>
    );
}

export default InfoTeamSection;
