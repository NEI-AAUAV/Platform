import React from "react";
import {Row, Col} from "react-bootstrap";
import "./index.css";

/** Card-like block for use in timelines
 * 
 *  Props:
 *   - moment: date of the event
 *   - title
 *   - body: event text
 *   - image: marker image src
 */
const TimelineItem = (props) => {

    

    return(
        <Row className="justify-content-center my-5 timeline-item">
            <Col>
                <div className="timeline-card px-4 pt-4 pb-2 text-center">
                    <h3 className="mb-3">{props.title}</h3>
                    <p>{props.body}</p>
                </div>
            </Col>

            <Col md="1" className="timeline-marker px-0 d-flex justify-content-center">
                <img src={process.env.PUBLIC_URL + props.image} />
            </Col>

            <Col className="timeline-date">
                <span>{props.moment}</span>
            </Col>
        </Row>
    )
}

export default TimelineItem;