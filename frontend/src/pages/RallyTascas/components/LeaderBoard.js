import { useEffect, useState } from "react";
import service from 'services/RallyTascasService';

import GenericCard from "./GenericCard";

function suffix_for_ordinal(i) {
    const j = i % 10;
    const k = i % 100;

    if (j === 1 && k !== 11) return "st";
    else if (j === 2 && k !== 12) return "nd";
    else if (j === 3 && k !== 13) return "rd";
    else return "th";
}

const LeaderBoardEntry = (props) => {
    const placeSuffix = suffix_for_ordinal(props.classification);
    const headerColor = props.classification < 4 ? "#FC8551" : "#FFFFFF";
    const classification = props.classification < 0 ? props.placement : props.classification;

    const HeaderText = (props) => (
        <p className="m-0" style={{
            color: headerColor,
        }}>
            {props.children}
        </p>
    );

    return (
        <div>
            <div className="d-flex justify-content-between">
                <HeaderText>{classification}{placeSuffix} place</HeaderText>
                <HeaderText>{props.total} pts</HeaderText>
            </div>
            <p className="text-white">{props.name}</p>
        </div>
    );
}

const LeaderBoard = () => {
    const [entries, setEntries] = useState([]);

    // Get API data when component renders
    useEffect(() => {
        service.getTeams()
            .then((data) => {
                const sortedData = data.sort((a, b) => {
                    if (a.classification < 0 && b.classification > 0) {
                        return 1
                    }
                    if (a.classification > 0 && b.classification < 0) {
                        return -1
                    }
                    if (a.classification > b.classification) {
                        return 1
                    }
                    if (a.classification < b.classification) {
                        return -1
                    }
                    return 0;
                });
                setEntries(sortedData);
            });
    }, []);

    return <GenericCard>
        {entries.map((entry, i) =>
            <LeaderBoardEntry key={i} placement={i + 1} {...entry} />
        )}
    </GenericCard>;
}

export default LeaderBoard;
