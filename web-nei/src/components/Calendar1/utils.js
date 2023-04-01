
export function getWeeklyIntervals(startDate, endDate) {
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
      start: i === 0 ? startDate : intervalStart,
      end: i === weeks - 1 ? endDate : intervalEnd,
    });
  }

  return intervals;
}
