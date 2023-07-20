import React, { useEffect, useState } from "react";
import Timeline from "./Timeline";
import Typist from 'react-typist';

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
            <h2 className="text-center"><Typist>História do NEI</Typist></h2>
            <Timeline events={data}></Timeline>
        </div>
    )
}
