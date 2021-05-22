import React, {useState, useEffect} from "react";
import {
    Calendar as ReactCalendar,
    Views,
    momentLocalizer
} from 'react-big-calendar';
import moment from 'moment';
import "./index.css";


let allViews = Object.keys(Views).map(k => Views[k]);
const localizer = momentLocalizer(moment);

// Colorize events acoording to type
const eventStyleGetter = (event, start, end, isSelected) => {
    // 
    let color = "#147a26";
    if (event.['title'].indexOf("MEI")>=0) {
        color = "#015a65";
    } else if (event.['title'].indexOf("[3A]")>=0) {
        color = "#018798";
    } else if (event.['title'].indexOf("[2A]")>=0) {
        color = "#01abc0";
    } else if (event.['title'].indexOf("[1A]")>=0) {
        color = "#01cae4";
    } else if (["FERIADO", "Época de", "Férias"].some(term => event['title'].toLowerCase().indexOf(term.toLowerCase())>=0)) {
        color = "#FFA200";
    }

    return {
        style: {
            'backgroundColor': color
        }
    }
}

// COMPONENT
const NEICalendar = () => {
    
    // State
    const [events, setEvents] = useState([]);
    const [calendarSince, setCalendarSince] = useState(null);
    const [calendarTo, setCalendarTo] = useState(null);

    // On render, initialize calendarSince and calendarTo based on current moment
    useEffect(() => {
        timespanChanged(new Date());
    }, []);

    // Get events from API on render
    useEffect(() => {
        if(calendarSince!=null && calendarTo!=null) {
            const tmin = `${calendarSince.getFullYear()}-${calendarSince.getMonth()+1}-${calendarSince.getDate()}T00%3A00%3A00%2B01%3A00`;
            const tmax = `${calendarTo.getFullYear()}-${calendarTo.getMonth()+1}-${calendarTo.getDate()}T00%3A00%3A00%2B01%3A00`;
            fetch(`https://www.googleapis.com/calendar/v3/calendars/7m2mlm7k1huomjeaa45gbhog0k%40group.calendar.google.com/events?key=AIzaSyDnT8fO6ARjx3OxMJCimhenNDLTkGuOmjE&timeMin=${tmin}&timeMax=${tmax}&singleEvents=true&maxResults=9999`)
                .then(res => res.json())
                .then(json => {
                    console.log(json['items']);
                    let apiEvents = [];
                    json['items'].forEach(e => {
                        apiEvents.push({
                            'id': e['id'],
                            'title': e['summary'],
                            'start': new Date(e['start']['date']),
                            'end': new Date(e['end']['date']),
                            
                        });
                    });
                    console.log(apiEvents);
                    setEvents(apiEvents);
                });
        }
    }, [calendarSince, calendarTo]);

    // On navigate, update next and prev moments and recall API
    const timespanChanged = (date) => {
        let next = new Date(date);
        let prev = new Date(date);

        if (date.getMonth()==11) {
            next.setMonth(0);
            next.setYear(date.getFullYear()+1);
            prev.setMonth(date.getMonth()-1);
        } else if (date.getMonth()==0) {
            next.setMonth(date.getMonth()+1);
            prev.setMonth(11);
            prev.setYear(date.getFullYear()-1);
        } else {
            next.setMonth(date.getMonth()+1);
            prev.setMonth(date.getMonth()-1);
        }

        setCalendarSince(prev);
        setCalendarTo(next);
    }

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
            eventPropGetter={eventStyleGetter}
            localizer={localizer}
            onNavigate={(date) => timespanChanged(date)}
        />
    );
}

export default NEICalendar;