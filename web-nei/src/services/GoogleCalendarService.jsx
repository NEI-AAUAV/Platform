import config from "config";
import axios from "axios";

const calendarIds = [
  // Academic calendar (years, courses, school calendar) and past NEI events
  "7m2mlm7k1huomjeaa45gbhog0k@group.calendar.google.com",
  // NEI events
  "635146afc8d5f0c65051c051fc2e57ee09f47865da1c528d014e5be284fa5888@group.calendar.google.com",
];
const key = config.GOOGLE_CALENDAR_API_KEY;

const GoogleCalendarService = {
  // Documentation:
  // https://developers.google.com/calendar/api/v3/reference/events/list
  // Do not use createClient since it injects the token, which invalidates the request

  async getCalendarEvents(
    calendarId,
    { timeMin, timeMax, singleEvents = true, maxResults = 9999 }
  ) {
    return await axios.get(
      `${config.GOOGLE_CALENDAR_URL}/calendars/${encodeURIComponent(
        calendarId
      )}/events`,
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

  // Merges the events of all calendars. A calendar that fails to load is skipped,
  // so one unavailable calendar doesn't hide the events of the others.
  async getEvents(params) {
    const results = await Promise.allSettled(
      calendarIds.map((id) => this.getCalendarEvents(id, params))
    );
    const fulfilled = results.filter((r) => r.status === "fulfilled");
    if (fulfilled.length === 0) {
      throw results[0].reason;
    }
    results
      .filter((r) => r.status === "rejected")
      .forEach((r) =>
        console.error("Failed to load calendar events", r.reason)
      );
    return { data: { items: fulfilled.flatMap((r) => r.value.data.items) } };
  },
};

// Export a singleton service
export default GoogleCalendarService;
