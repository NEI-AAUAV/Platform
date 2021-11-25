import React from "react";
import PropTypes from "prop-types";

import './index.css';

// Based on https://dev.to/bravemaster619/simplest-way-to-embed-a-youtube-video-in-your-react-app-3bk2

/*
<iframe 
    width="560" 
    height="315" 
    src="https://www.youtube.com/embed/videoseries?list=PL0-X-dbGZUABPg-FWm3tT7rCVh6SESK2d" 
    title="YouTube video player" 
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
    allowfullscreen
></iframe>
*/
const YoutubeEmbed = ({ embedId, playlist, className }) => (
    <div className={"video-responsive " + className}>
        <iframe
            width="853"
            height="480"
            src={playlist ? `https://www.youtube.com/embed/videoseries?list=${embedId}` : `https://www.youtube.com/embed/${embedId}`}
            frameBorder="0"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowFullScreen
            title="Youtube video player"
        />
    </div>
);

YoutubeEmbed.propTypes = {
    embedId: PropTypes.string.isRequired
};

export default YoutubeEmbed;
