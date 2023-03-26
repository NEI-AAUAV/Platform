export function monthsPassed(date) {
  const today = new Date();
  let months = (today.getFullYear() - date.getFullYear()) * 12;
  months -= date.getMonth();
  months += today.getMonth();
  return months;
}
