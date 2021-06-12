import React, { useEffect, useState } from "react";
import Timeline from "./Timeline";
import Typist from 'react-typist';

const History = () => {

    const [data, setData] = useState([]);

    // fetch timeline data from API
    useEffect(() => {
        fetch(process.env.REACT_APP_API + "/history")
            .then(response => response.json())
            .then((response) => {
                if('data' in response) {
                    setData(response["data"]);
                }
            });
    }, []);
    
    console.log(data)

    return(
        <div>
            <h2 className="text-center"><Typist>História do NEI</Typist></h2>
            <Timeline events={data}></Timeline>
        </div>
    )
}

export default History;