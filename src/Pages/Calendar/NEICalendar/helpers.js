
// Colorize events acoording to type
const eventStyleGetter = (event, start, end, isSelected) => {
    let color = "rgba(20, 122, 38";
    if (event.['title'].indexOf("MEI")>=0) {
        color = "rgba(1, 90, 101";
    } else if (event.['title'].indexOf("[3A]")>=0) {
        color = "rgba(1, 135, 152";
    } else if (event.['title'].indexOf("[2A]")>=0) {
        color = "rgba(1, 171, 192";
    } else if (event.['title'].indexOf("[1A]")>=0) {
        color = "rgba(1, 202, 228";
    } else if (["FERIADO", "Época de", "Férias"].some(term => event['title'].toLowerCase().indexOf(term.toLowerCase())>=0)) {
        color = "rgba(255, 162, 0";
    }

    // Reduce opacity in past events
    var yesterday = new Date((new Date()).valueOf() - 1000*60*60*24);
    color += (end <= yesterday) ? ", 0.6)" : ", 1)";

    return {
        style: {
            'backgroundColor': color
        }
    }
}

// Tooltip acessor
// This method returns the text tooltip given an event 
const tooltipAcessor = (e) => {
    let message = e['title'] + '\n___\n';

    if (e['allDay']) {
        message += "Todo o dia";
    }
    // If not all day, compute text for time span
    else if ((Math.abs(e['end']-e['start'])/(1000 * 60 * 60))<24) {
        // Same day (less than 24 hours diff)
        message += `Das ${zeroPad(e['start'].getHours()+1, 2)}:${zeroPad(e['start'].getMinutes(), 2)} às ${zeroPad(e['end'].getHours()+1, 2)}:${zeroPad(e['end'].getMinutes(), 2)}`;
    // Else, different days
    // On same month
    } else if (e['start'].getMonth() == e['end'].getMonth()) {
        message += `De dia ${e['start'].getDate()} às ${zeroPad(e['start'].getHours()+1, 2)}:${zeroPad(e['start'].getMinutes(), 2)} a dia ${e['end'].getDate()} às ${zeroPad(e['end'].getHours()+1, 2)}:${zeroPad(e['end'].getMinutes(), 2)}`;
    // On different months
    } else {
        message += `De ${e['start'].getDate()} de ${months[e['start'].getMonth()]} às ${zeroPad(e['start'].getHours()+1, 2)}:${zeroPad(e['start'].getMinutes(), 2)} até ${e['end'].getDate()} de ${months[e['end'].getMonth()]} às ${zeroPad(e['end'].getHours()+1, 2)}:${zeroPad(e['end'].getMinutes(), 2)}`;
    }

    return message;
}

// Add leading zeros to numbers (Example: (3, 2) => 03)
const zeroPad = (num, places) => String(num).padStart(places, '0');

const months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
 
export {eventStyleGetter, tooltipAcessor, zeroPad, months};