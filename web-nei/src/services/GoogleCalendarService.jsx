import config from "config";
import axios from "axios";

const calendarId = "7m2mlm7k1huomjeaa45gbhog0k@group.calendar.google.com";
const key = "AIzaSyDnT8fO6ARjx3OxMJCimhenNDLTkGuOmjE";

const GoogleCalendarService = {
  // Documentation:
  // https://developers.google.com/calendar/api/v3/reference/events/list
  // Do not use createClient since it injects the token, which invalidates the request

  async getEvents({
    timeMin,
    timeMax,
    singleEvents = true,
    maxResults = 9999,
  }) {
    return await axios.get(
      `${config.GOOGLE_CALENDAR_URL}/calendars/${calendarId}/events`,
      {
        params: {
          key,
          timeMin,
          timeMax,
          singleEvents,
          maxResults,
          orderBy: "startTime",
        },
      }
    );
  },
};

// Export a singleton service
export default GoogleCalendarService;
