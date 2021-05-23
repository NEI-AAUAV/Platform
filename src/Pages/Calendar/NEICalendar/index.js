import React, {useState, useEffect} from "react";
import {
    Calendar as ReactCalendar,
    momentLocalizer
} from 'react-big-calendar';
import moment from 'moment';
import "./index.css";


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

 // Tooltip acessor
// This method returns the text tooltip given an event 
const tooltipAcessor = (e) => {    
    if (e['allDay']) {
        return "All day";
    }
    // If not all day, compute text for time span
    if ((Math.abs(e['end']-e['start'])/(1000 * 60 * 60))<24) {
        // Same day (less than 24 hours diff)
        return `From ${zeroPad(e['start'].getHours()+1, 2)}:${zeroPad(e['start'].getMinutes(), 2)} to ${zeroPad(e['end'].getHours()+1, 2)}:${zeroPad(e['end'].getMinutes(), 2)}`;
    } else {
        // Else, different days
        if (e['start'].getMonth() == e['end'].getMonth()) {
            // On same month
            return `From ${dayString(e['start'].getDate())} at ${zeroPad(e['start'].getHours()+1, 2)}:${zeroPad(e['start'].getMinutes(), 2)} to ${dayString(e['end'].getDate())} at ${zeroPad(e['end'].getHours()+1, 2)}:${zeroPad(e['end'].getMinutes(), 2)}`;
        } else {
            // On different months
            return `From ${months[e['start'].getMonth()]} the ${dayString(e['start'].getDate())} at ${zeroPad(e['start'].getHours()+1, 2)}:${zeroPad(e['start'].getMinutes(), 2)} to ${months[e['end'].getMonth()]} the ${dayString(e['end'].getDate())} at ${zeroPad(e['end'].getHours()+1, 2)}:${zeroPad(e['end'].getMinutes(), 2)}`;
        }
    }
    return "";
}

// Add leading zeros to numbers (Example: (3, 2) => 03)
const zeroPad = (num, places) => String(num).padStart(places, '0');

// Convert day to string (Xst/Xnd/Xrd/Xth) (Example: (1)=>"1st")
const dayString = (day) => {
    let append = "th";
    switch(day) {
        case 1:
            append = "st";
            break;
        case 2:
            append = "nd";
            break;
        case 3:
            append = "rd";
            break;
    }
    return `${day}${append}`;
}

const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

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
        />
    );
}

export default NEICalendar;