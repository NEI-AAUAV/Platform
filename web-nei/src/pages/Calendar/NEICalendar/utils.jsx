/**
 * Function to convert a Date object to a key string in the format `YYYY-MM-DD`.
 *
 * @example
 * dateKey(new Date(2023, 0, 1)) // "2023-01-01"
 * dateKey(2023, 0, 1) // "2023-01-01"
 * dateKey(2023) // "2023-01-01"
 */
export function dateKey(year, month = 0, day = 1) {
  let date;
  if (arguments.length === 1 && year instanceof Date) {
    // Process Date object
    date = year;
  } else if ([year, month, day].every(Number.isInteger)) {
    // Construct a Date object from the year, month, and day arguments
    date = new Date(year, month, day);
  } else {
    throw new Error("Invalid arguments");
  }
  return date.toLocaleDateString("en-CA");
}

/**
 * Divide a date interval into weekly intervals.
 *
 * @param {Date} startDate    The start date of the interval
 * @param {Date} endDate      The end date of the interval
 * @param {Date} [sinceDate]  The start limit
 * @param {Date} [toDate]     The end limit
 * @returns {Array.<{weekStart: Date, weekEnd: Date}>} An array of objects representing the weekly intervals
 *
 * @example
 * // Returns an array of 4 objects, representing the 4 weeks from January 2023 starting on Sunday and ending on Saturday
 * getWeeklyIntervals(new Date("2023-01-01"), new Date("2023-01-31"))
 */
export function getWeeklyIntervals(startDate, endDate, sinceDate, toDate) {
  // Constraint the interval to the limits, if provided
  if (sinceDate && startDate.getTime() < sinceDate.getTime()) {
    startDate = sinceDate;
  }
  if (toDate && toDate.getTime() < endDate.getTime()) {
    endDate = toDate;
  }

  // Set the start date to the Sunday before the actual start date
  const start = new Date(startDate);
  start.setDate(start.getDate() - start.getDay());

  // Set the end date to the Saturday after the actual end date
  const end = new Date(endDate);
  end.setDate(end.getDate() + (6 - end.getDay()));

  // Calculate the number of weeks between the start and end dates
  const weeks = Math.ceil((end - start) / (7 * 24 * 60 * 60 * 1000));

  // Create an array to hold the weekly intervals
  const intervals = [];

  // Loop through the weeks and add each interval to the array
  for (let i = 0; i < weeks; i++) {
    const intervalStart = new Date(start);
    intervalStart.setDate(intervalStart.getDate() + i * 7);
    const intervalEnd = new Date(intervalStart);
    intervalEnd.setDate(intervalEnd.getDate() + 6);
    intervals.push({
      weekStart: i === 0 ? startDate : intervalStart,
      weekEnd: i === weeks - 1 ? endDate : intervalEnd,
    });
  }

  return intervals;
}

// Leading "[...]" group of an event title, e.g. "[NEI/NEECT] Palestra" -> "NEI/NEECT"
const ENTITIES_REGEX = /^\[([^\]]*)\]/;
// Entities in a group can be separated by "/", "," or " e " (e.g. "[NEECT E NEEETA]")
const ENTITY_SEPARATOR_REGEX = /[/,]|\s+e\s+/i;

/**
 * Parse the entities (student groups) that organize an event from its title.
 *
 * @example
 * getEntities("[NEI, NEECT] Arraial") // ["NEI", "NEECT"]
 * getEntities("Feira do DETI") // []
 *
 * @param {string} title
 * @returns {string[]} The uppercased entities, or an empty array if none
 */
export function getEntities(title) {
  const match = ENTITIES_REGEX.exec(title);
  if (!match) return [];
  return match[1]
    .split(ENTITY_SEPARATOR_REGEX)
    .map((entity) => entity.trim().toUpperCase())
    .filter(Boolean);
}

/**
 * Find the category of an event from its title.
 *
 * Categories with `prefixes` are matched first. Otherwise, an event is NEI's when
 * NEI is one of its entities (possibly alongside others), and has no category
 * when it only has other entities. Events without entities default to NEI.
 *
 * @param {string} title
 * @param {Object.<string, {prefixes?: string[]}>} categories
 * @returns {Object|null} The category, with its `key`, or `null` if the event
 *                        only belongs to other entities
 */
export function getCategory(title, categories) {
  const trimmedTitle = title.trim();
  for (const [key, c] of Object.entries(categories)) {
    if (c.prefixes?.some((p) => trimmedTitle.startsWith(p))) {
      return { ...c, key };
    }
  }
  const entities = getEntities(trimmedTitle);
  if (entities.length > 0 && !entities.includes("NEI")) {
    return null;
  }
  return { ...categories.NEI, key: "NEI" };
}
