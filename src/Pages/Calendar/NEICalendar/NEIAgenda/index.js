import React from "react";
import {eventStyleGetter} from "../helpers";

import "./index.css";

const NEIAgenda = (props) => {
    return (
        <div className="agendaEvent" style={eventStyleGetter(props.event, null, null, false)['style']}>
            {props.title}
        </div>
    );
}

export default NEIAgenda;
