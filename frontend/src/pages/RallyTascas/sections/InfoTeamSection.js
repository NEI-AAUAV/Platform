import { useEffect, useState } from "react";
import { Card, Text } from "@nextui-org/react";
import LeaderBoard from "../components/LeaderBoard";
import { AiOutlineArrowLeft } from 'react-icons/ai';
import "../index.css";


const InfoTeamSection = ({ team, goBack }) => {
    const [mobile, setMobile] = useState(false);

    useEffect(() => {
        function handleResize() {
            setMobile(window.innerWidth < 960)
        }
        handleResize();
        window.addEventListener('resize', handleResize);
        return (() => {
            window.removeEventListener('resize', handleResize)
        });
    }, [])

    if (!team) return null;

    return (
        <>
            <div className="mb-2" style={{ color: "rgb(255, 70, 70)", fontWeight: 'bold', cursor: 'pointer' }} onClick={goBack}>
                <AiOutlineArrowLeft />
                <span style={{ "vertical-align": "middle" }}>{' '}Go Back</span>
            </div>
            <div className="d-flex flex-wrap" style={{ justifyContent: "space-between", fontFamily: "Aldrich", width: "100%", justifyContent: "space-around" }}>
                <div className="rally-tascas-column">
                    <div className="rally-tascas-row">
                        <Card variant="bordered" className="rally-card-team-image">
                            <Card.Image
                                src={`../images/IconsTeamsSection/icon${team.id % 16 + 1}.png`}
                                objectFit="cover"
                                alt="Card image background"
                            />
                        </Card>
                    </div>
                    <div className="rally-tascas-row mt-4">
                        <Card variant="bordered" className="rally-card-team-name" >
                            <Card.Body>
                                <Text style={{ color: "#FC8551" }}>9th place</Text>
                                <Text h3 style={{ color: "white" }}>{team.name}</Text>
                            </Card.Body>
                        </Card>
                    </div>
                </div>
                <div className="rally-tascas-column">
                    <div className="rally-tascas-row">
                        <Card className="rally-card-team-information" >
                            <Card.Body className="pb-0">
                                <Text h3 style={{ color: "#FC8551", fontWeight: "bold" }}>{'>'} TEAM MEMBERS</Text>
                                <ol style={{ paddingLeft: "0px" }}>
                                    {team.members?.map((element, index) => (
                                        <ul key={index} style={{ color: "white", paddingLeft: "0px" }}>{element.name}</ul>
                                    ))}
                                </ol>
                            </Card.Body>
                        </Card>
                    </div>
                    <div className="rally-tascas-row">
                        <Card variant="bordered" className="rally-card-team-checkpoint">
                            <Card.Body className="pb-0">
                                <Text h3 style={{ color: "#FC8551", fontWeight: "bold" }}>{'>'} LAST CHECKPOINT</Text>
                                {team.times.length > 0 ? <>
                                    <Text style={{ color: "white" }}>Last Checkpoint</Text>
                                    <Text style={{ color: "white" }}>Score: <span style={{ color: "rgb(255, 70, 70)" }}>{team.time_scores.at(-1)} PTS</span></Text>
                                    <Text style={{ color: "white" }}>Date: {team.times.at(-1)?.split('T').at(-1)}</Text>
                                </> : (
                                    <div style={{
                                        textAlign: 'left', textTransform: 'inherit', marginTop: '0.5rem',
                                        fontSize: '1.4rem', fontFamily: 'Akshar', fontWeight: 'bold',
                                    }}>
                                        <p>Não passou por nenhum checkpoint.</p>
                                    </div>
                                )}
                            </Card.Body>
                        </Card>
                    </div>
                    <div className="rally-tascas-row">
                        <Card variant="bordered" className="rally-card-team-points">
                            <Card.Body className="pb-0">
                                <Text h3 style={{ color: "#FC8551", fontWeight: "bold" }}>{'>'} TOTAL SCORE</Text>
                                <Text style={{ color: "rgb(255, 70, 70)" }}>{team.total} pts</Text>
                            </Card.Body>
                        </Card>
                    </div>
                </div>
                <div className="rally-tascas-column px-3" style={{ maxWidth: 320, width: '100%', display: mobile ? 'none' : 'block' }}>
                    <LeaderBoard />
                </div>
            </div>
        </>
    );
}

export default InfoTeamSection;
