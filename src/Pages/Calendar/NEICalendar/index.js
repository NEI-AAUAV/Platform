import React, {useState, useEffect} from "react";
import {
    Calendar as ReactCalendar,
    momentLocalizer
} from 'react-big-calendar';
import moment from 'moment';
import NEIAgenda from "./NEIAgenda";
import {eventStyleGetter, tooltipAcessor, zeroPad, dayString, months} from "./helpers";
import "./index.css";

require('moment/locale/pt.js');

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
                        const start = 'date' in e['start'] ? e['start']['date'] : e['start']['dateTime'];
                        let end = 'date' in e['end'] ? e['end']['date'] : e['end']['dateTime'];
                        if ('date' in e['end']) {
                            let endDate = new Date(end);
                            endDate = endDate.setDate(endDate.getDate()-1);
                            end = endDate;
                        }
                        apiEvents.push({
                            'id': e['id'],
                            'title': e['summary'],
                            'start': new Date(start),
                            'end': new Date(end),
                            'allDay': 'date' in e['start']
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
            popup
            className="col-12 vh-100"
            events={events}
            views={['month', 'agenda']}
            step={60}
            showMultiDayTimes
            defaultDate={new Date()}
            eventPropGetter={eventStyleGetter}
            localizer={momentLocalizer(moment)}
            onNavigate={(date) => timespanChanged(date)}
            tooltipAccessor={(event) => tooltipAcessor(event)}
            components={{
                agenda: {
                    event: NEIAgenda
                }
            }}
            messages={{
                next: "Próximo",
                previous: "Anterior",
                today: "Hoje",
                month: "Mês",
                week: "Semana",
                day: "Dia",
                allDay: "Todo o dia"
            }}
        />
    );
}

export default NEICalendar;