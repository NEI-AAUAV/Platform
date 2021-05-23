
// Colorize events acoording to type
const eventStyleGetter = (event, start, end, isSelected) => {
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
 
export {eventStyleGetter, tooltipAcessor, zeroPad, dayString, months};