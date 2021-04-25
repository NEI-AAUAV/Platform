import React, { useState, useEffect } from "react";

const Homepage = () => {

    const [news, setNews] = useState([]);

    // Get API data when component renders
    useEffect(() => {
        fetch(process.env.REACT_APP_API + "/news")
            .then(response => response.json())
            .then((response) => {
                if('data' in response) {
                    setNews(response['data']);
                }
            });
    }, []);

    return (
        <div>
            <h1>Homepage</h1>

            <hr />
            <h2>Notícias</h2>
            {
                news.map(
                    n => <p>{n.title}</p>
                )
            }
        </div>
    );
}

export default Homepage;