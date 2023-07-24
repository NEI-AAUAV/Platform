import React from "react";
import TimelineItem from "../TimelineItem";
import "./index.css";


// Animation
const animationBase = parseFloat(import.meta.env.VITE_ANIMATION_BASE);
const animationIncrement = parseFloat(import.meta.env.VITE_ANIMATION_INCREMENT);


/** A vertical timeline that renders alternating windows
 * 
 * Props:
 *  - events: array of events, each of which should have the following properties:
 *      - moment: date of the event
 *      - title
 *      - body: event text
 *      - image: url for timeline marker image
 */
const Timeline = (props) => {

    return(
        <div className="timeline animation">
            {props.events.map((event, i) => {
                return(
                    <TimelineItem
                        moment={event.moment}
                        title={event.title}
                        body={event.body}
                        image={event.image}
                        className="slideUpFade"
                        style={{
                            animationDelay: animationBase + animationIncrement*i + "s",
                        }}
                    ></TimelineItem>
                );
            })}
        </div>
    )
}

export default Timeline;