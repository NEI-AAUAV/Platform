import React from "react";
import {
    Calendar as ReactCalendar,
    Views,
    momentLocalizer
} from 'react-big-calendar';
import moment from 'moment';
import events from '../events';
import "./index.css";


let allViews = Object.keys(Views).map(k => Views[k]);

const ColoredDateCellWrapper = ({ children }) =>
    React.cloneElement(React.Children.only(children), {
        style: {
            backgroundColor: 'lightblue',
        },
    });

const localizer = momentLocalizer(moment);


const NEICalendar = () => {
    return (
        <ReactCalendar
            className="col-12 vh-100"
            events={events}
            views={allViews}
            step={60}
            showMultiDayTimes
            max={new Date(2021, 12, 31)}
            defaultDate={new Date(2015, 3, 1)}
            components={{
                timeSlotWrapper: ColoredDateCellWrapper,
            }}
            localizer={localizer}
        />
    );
}

export default NEICalendar;