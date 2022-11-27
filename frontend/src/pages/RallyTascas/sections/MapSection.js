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
    return (
        <div className="mt-2">
            <h6 className="text-uppercase text-white map-item-title">
                {props.name}
            </h6>
            <p className="text-uppercase text-white map-item-subtitle">
                {props.points} PTS --/--/-- --:--
            </p>
        </div>
    );
}

const PreviousCheckpoints = () => {
    const dummyCheckpoints = [
        { name: "Rua 1", points: 10 },
        { name: "Rua 2", points: 5 },
    ];
    const checkpointItems = dummyCheckpoints.map((checkpoint, i) =>
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

    // Get API data when component renders
    useEffect(() => {
        service.getCheckpoint().then((data) => setNextData(data));
    }, []);

    return (
        <div className="map-root-container row m-2">
            <div className="col-12 col-md-4 px-3">
                <NextShot {...nextData} />
                <NextCheckpointCard name={nextData.name} />
            </div>
            <div className="col-12 col-md-4 px-3">
                <PreviousCheckpoints />
            </div>
            <div className="col-4 d-none d-md-block px-3">
                <LeaderBoard />
            </div>
        </div>
    );
}

export default MapSection;
