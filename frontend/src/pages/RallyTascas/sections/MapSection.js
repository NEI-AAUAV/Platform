import './MapSection.css';

const GenericCard = (props) => {
    return (
        <div className="map-outline-card p-3 pt-4 mb-3">
            {props.children}
        </div>
    );
}

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

const NextShot = () => {
    return (
        <InfoCard title="Next Shot" subtitle="Shot Name">
            <p className="text-white text-uppercase mt-4 shot-description">
                Shot Description and slogan.
            </p>
            <p className="text-white text-uppercase text-justify shot-description">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur consequat tristique dui ut placerat. Morbi quis lacus lacus. Vestibulum.
            </p>
        </InfoCard>
    );
}

const NextCheckpointCard = () => {
    return <InfoCard title="Next Checkpoint" subtitle="Checkpoint" />;
}

const Checkpoint = (props) => {
    return (
        <div className="mt-2">
            <h6 className="text-uppercase text-white map-item-title">
                {props.name}
            </h6>
            <p transform="text-uppercase text-white map-item-subtitle">
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

function ordinal_suffix_of(i) {
    var j = i % 10,
        k = i % 100;
    if (j == 1 && k != 11) {
        return i + "st";
    }
    if (j == 2 && k != 12) {
        return i + "nd";
    }
    if (j == 3 && k != 13) {
        return i + "rd";
    }
    return i + "th";
}

const LeaderBoardEntry = (props) => {
    const placeString = ordinal_suffix_of(props.placement + 1);

    return (
        <div>
            <div className="d-flex justify-content-between">
                <p style={{ color: "#FC8551" }} className="m-0 map-item-subtitle">
                    {placeString} place
                </p>
                <p style={{ color: "#FC8551" }} className="m-0 map-item-subtitle">
                    {props.points} pts
                </p>
            </div>
            <p className="text-white">{props.team}</p>
        </div>
    );
}

const LeaderBoard = () => {
    const dummyEntries = [
        { team: "Nei Admin", points: 10000 },
        { team: "Placeholder 1", points: 30 },
        { team: "Placeholder 2", points: 20 },
        { team: "Placeholder 3", points: 10 },
        { team: "Nei Imagem", points: -20 },
    ];
    const entryItems = dummyEntries.map((entry, i) =>
        <LeaderBoardEntry key={i} placement={i} {...entry} />
    );

    return <GenericCard>{entryItems}</GenericCard>;
}

const MapSection = () => {
    return (
        <div className="map-root-container row m-2">
            <div className="col-12 col-md-4 px-3">
                <NextShot />
                <NextCheckpointCard />
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
