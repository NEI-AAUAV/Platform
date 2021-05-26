import React, { useEffect, useState } from "react";
import Timeline from "./Timeline";

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
            <h1 className="text-center">História do NEI</h1>
            <Timeline events={data}></Timeline>
        </div>
    )
}

export default History;