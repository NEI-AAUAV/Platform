import React, { useEffect, useState } from "react";
import Timeline from "./Timeline";

import service from 'services/NEIService';

export function Component() {
    const [data, setData] = useState([]);

    // fetch timeline data from API
    useEffect(() => {
        service.getHistory()
            .then((data) => {
                setData(data);
            });
    }, []);

    return (
        <div>
            <h2 className="text-center">História do NEI</h2>
            <Timeline events={data}></Timeline>
        </div>
    )
}
