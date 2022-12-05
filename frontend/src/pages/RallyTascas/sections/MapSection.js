import { useEffect, useState } from "react";
import { Text } from "@nextui-org/react";
import service from 'services/RallyTascasService';

import GenericCard from "../components/GenericCard";
import LeaderBoard from "../components/LeaderBoard";

import './MapSection.css';

const InfoCard = (props) => {
    return (
        <GenericCard style={{ maxWidth: 320, width: '100%', margin: 'auto' }}>
            <h3 style={{ color: "#FC8551", fontWeight: 'bold' }} className="text-center map-card-title mb-2">
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

export const Checkpoint = (props) => {
    let formattedDate = "", formattedHours = "";
    if (!isNaN(props.time)) {
        let day = props.time.getDate();
        let month = props.time.getMonth() + 1;
        let year = props.time.getFullYear();
        formattedDate = `${day}/${month}/${year}`;

        let hours = props.time.getHours();
        let minutes = props.time.getMinutes();
        formattedHours = `${hours}:${minutes}`
    }

    const questionColor = props.question ? "rgb(70, 255, 70)" : "rgb(255, 70, 70)";
    const tookMinutes = Math.floor(props.took / 60);
    const tookSeconds = props.took % 60;

    const formatMod = (num, label) => num > 0 ? (num > 1 ? `${num}x` : "") + label : "";
    const pukesString = formatMod(props.pukes, "🤮");
    const skipsString = formatMod(props.skips, "⏭️");
    return (
        <div className="mt-2 w-100" style={{fontFamily: 'Akshar'}}>
            <div className="d-flex justify-content-between">
                <h6 className="text-uppercase text-white map-item-title">
                    {props.name}
                </h6>
                <p className="map-item-subtitle text-white m-0">
                    {pukesString} {skipsString}
                </p>
                <p className="text-uppercase map-item-subtitle m-0" style={{ color: questionColor }}>
                    {props.question === true ? "Acertou" : props.question === false ? "Errou" : ""}
                </p>
            </div>
            <div className="d-flex justify-content-between">
                <p className="text-uppercase text-white map-item-subtitle">
                    {formattedDate} {formattedHours}
                </p>
                <p className="map-item-subtitle m-0" style={{ color: "#FC8551" }}>
                    {tookMinutes > 0 ? `${tookMinutes}m` : ""}
                    {tookSeconds > 0 ? `${tookSeconds}s` : ""}
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
        <div style={{ maxWidth: 320, width: '100%', margin: 'auto' }}>
            <Text h3 className="text-uppercase" style={{ color: "#FC8551", fontWeight: "bold", fontFamily: 'Aldrich', paddingTop: '1.25rem' }}>
                {'>'} Previous Checkpoints
            </Text>
            <div className="d-flex flex-column">
                {checkpointItems.length ? checkpointItems
                    :
                    <div style={{ textAlign: 'left', marginTop: '0.5rem', fontSize: '1.4rem', fontFamily: 'Akshar', fontWeight: 'bold' }}>
                        <p>Não passaste nenhum checkpoint.</p><p>Vai beber!</p>
                    </div>
                }
            </div>
        </div>
    );
}

const MapSection = () => {
    const [nextData, setNextData] = useState({});
    const [previousCheckpoints, setPreviousCheckpoints] = useState([]);
    const [mobile, setMobile] = useState(false);

    // Get API data when component renders
    useEffect(() => {
        let loading = false;
        const checkPointsPromise = service.getCheckpoints();

        function fetchEverything() {
            if (loading) return;

            loading = true;

            service.getCurrentCheckpoint().then((data) => setNextData(data));
            Promise.all([
                service.getOwnTeam(),
                checkPointsPromise,
            ]).then(async ([team, checkpoints]) => {
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

            loading = false;
        }

        fetchEverything();

        const intervalId = setInterval(fetchEverything, 60_000);

        function handleResize() {
            setMobile(window.innerWidth < 960)
        }
        handleResize();
        window.addEventListener('resize', handleResize);
        return (() => {
            window.removeEventListener('resize', handleResize)
            clearInterval(intervalId);
        });
    }, []);

    return (
        <div className="map-root-container justify-content-around row m-0 mt-sm-5 mt-2">
            <div className="col-12 col-md-4 px-3 mb-4">
                <NextShot {...nextData} />
                <NextCheckpointCard name={nextData.name} />
            </div>
            <div className="col-12 col-md-4 px-3">
                <PreviousCheckpoints checkpoints={previousCheckpoints} />
            </div>
            <div className="col-4 px-3" style={{ maxWidth: 320, width: '100%', display: mobile ? 'none' : 'block' }}>
                <LeaderBoard />
            </div>
        </div>
    );
}

export default MapSection;
