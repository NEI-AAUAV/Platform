import React, {useState, useEffect} from "react";
import {
    Calendar as ReactCalendar,
    Views,
    momentLocalizer
} from 'react-big-calendar';
import moment from 'moment';
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
    const [events, setEvents] = useState([]);

    useEffect(() => {
        console.log("STARTED REQUEST");
        fetch('https://www.googleapis.com/calendar/v3/calendars/7m2mlm7k1huomjeaa45gbhog0k%40group.calendar.google.com/events?key=AIzaSyDnT8fO6ARjx3OxMJCimhenNDLTkGuOmjE&timeMin=2021-04-25T00%3A00%3A00%2B01%3A00&timeMax=2021-06-06T00%3A00%3A00%2B01%3A00&singleEvents=true&maxResults=9999')
            .then(res => res.json())
            .then(json => {
                console.log(json['items']);
                let apiEvents = [];
                json['items'].forEach(e => {
                    apiEvents.push({
                        'id': e['id'],
                        'title': e['summary'],
                        'start': new Date(e['start']['date']),
                        'end': new Date(e['end']['date'])
                    });
                });
                console.log(apiEvents);
                setEvents(apiEvents);
            });
    }, []);

    return (
        events.length>0
        &&
        <ReactCalendar
            className="col-12 vh-100"
            events={events}
            views={allViews}
            step={60}
            showMultiDayTimes
            defaultDate={new Date()}
            components={{
                timeSlotWrapper: ColoredDateCellWrapper,
            }}
            localizer={localizer}
        />
    );
}

export default NEICalendar;