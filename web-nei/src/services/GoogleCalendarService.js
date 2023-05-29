import config from "config";
import { createClient } from "./client";

const client = createClient(config.GOOGLE_CALENDAR_URL);

const calendarId = "7m2mlm7k1huomjeaa45gbhog0k%40group.calendar.google.com";
const key = "AIzaSyDnT8fO6ARjx3OxMJCimhenNDLTkGuOmjE";

class GoogleCalendarService {
  // Documentation:
  // https://developers.google.com/calendar/api/v3/reference/events/get

  async getEvents({
    timeMin,
    timeMax,
    singleEvents = true,
    maxResults = 9999,
  }) {
    return await client.get(`/calendars/${calendarId}/events`, {
      params: {
        key,
        timeMin,
        timeMax,
        singleEvents,
        maxResults,
        orderBy: "startTime",
      },
    });
  }
}

// Export a singleton service
export default new GoogleCalendarService();
