import { useEffect, useState } from "react";
import service from 'services/RallyTascasService';

import GenericCard from "../components/GenericCard";
import LeaderBoard from "../components/LeaderBoard";

import './MapSection.css';

const InfoCard = (props) => {
    return (
        <GenericCard>
            <h3 style={{ color: "#FC8551" }} className="text-center map-card-title">
                {props.title}
            </h3>
            <h2 className="text-center text-white map-card-subtitle">
                {props.subtitle}
            </h2>
            {props.children}
        </GenericCard>
    );
}

const NextShot = (props) => {
    return (
        <InfoCard title="Next Shot" subtitle={props.shot_name}>
            <p style={{ whiteSpace: "pre-line" }} className="text-white text-uppercase mt-4 shot-description">
                {props.description}
            </p>
        </InfoCard>
    );
}

const NextCheckpointCard = (props) => {
    return <InfoCard title="Next Checkpoint" subtitle={props.name} />;
}

const Checkpoint = (props) => {
    const day = props.time.getDate();
    const month = props.time.getMonth() + 1;
    const year = props.time.getFullYear();
    const formattedDate = `${day}/${month}/${year}`

    const hours = props.time.getHours();
    const minutes = props.time.getMinutes();
    const formattedHours = `${hours}:${minutes}`

    const questionColor = props.question ? "rgb(70, 255, 70)" : "rgb(255, 70, 70)";
    const tookMinutes = Math.floor(props.took / 60);
    const tookSeconds = props.took % 60;

    const formatMod = (num, label) => num > 0 ? (num > 1 ? `${num}x` : "") + label : "";
    const pukesString = formatMod(props.pukes, "🤮");
    const skipsString = formatMod(props.pukes, "⏭️");

    return (
        <div className="mt-2">
            <div className="d-flex justify-content-between">
                <h6 className="text-uppercase text-white map-item-title">
                    {props.name}
                </h6>
                <p className="map-item-subtitle text-white m-0">
                    {pukesString} {skipsString}
                </p>
                <p className="text-uppercase map-item-subtitle m-0" style={{ color: questionColor }}>
                    {props.question ? "Acertou" : "Errou"}
                </p>
            </div>
            <div className="d-flex justify-content-between">
                <p className="text-uppercase text-white map-item-subtitle">
                    {formattedDate} {formattedHours}
                </p>
                <p className="map-item-subtitle m-0" style={{ color: "#FC8551" }}>
                    {tookMinutes > 0 ? `${tookMinutes}m` : ""}{tookSeconds}s
                </p>
            </div>
        </div>
    );
}

const PreviousCheckpoints = (props) => {
    const checkpointItems = props.checkpoints.map((checkpoint, i) =>
        <Checkpoint key={i} {...checkpoint} />
    );

    return (
        <>
            <h3 style={{ color: "#FC8551" }} className="text-uppercase map-card-subtitle">
                &gt; Previous <br /> Checkpoints
            </h3>
            <div className="d-flex flex-column">
                {checkpointItems}
            </div>
        </>
    );
}

const MapSection = () => {
    const [nextData, setNextData] = useState({});
    const [previousCheckpoints, setPreviousCheckpoints] = useState([]);

    // Get API data when component renders
    useEffect(() => {
        service.getCurrentCheckpoint().then((data) => setNextData(data));
        Promise.all([
            service.getOwnTeam(),
            service.getCheckpoints(),
        ]).then(([team, checkpoints]) => {
            let merged = [];
            const len = Math.min(
                team.times.length,
                team.time_scores.length,
                team.question_scores.length,
                checkpoints.length
            );
            for (let i = 0; i < len; i++) {
                const checkpoint = checkpoints[i];
                checkpoint.took = team.time_scores[i];
                checkpoint.question = team.question_scores[i];
                checkpoint.time = new Date(team.times[i]);
                checkpoint.pukes = team.pukes[i] ?? 0;
                checkpoint.skips = team.skips[i] ?? 0;
                merged.push(checkpoint);
            }
            setPreviousCheckpoints(merged)
        });
    }, []);

    return (
        <div className="map-root-container row m-2">
            <div className="col-12 col-md-4 px-3">
                <NextShot {...nextData} />
                <NextCheckpointCard name={nextData.name} />
            </div>
            <div className="col-12 col-md-4 px-3">
                <PreviousCheckpoints checkpoints={previousCheckpoints} />
            </div>
            <div className="col-4 d-none d-md-block px-3">
                <LeaderBoard />
            </div>
        </div>
    );
}

export default MapSection;