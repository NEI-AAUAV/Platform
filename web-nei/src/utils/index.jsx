export function monthsPassed(date) {
  const today = new Date();
  let months = (today.getFullYear() - date.getFullYear()) * 12;
  months -= date.getMonth();
  months += today.getMonth();
  return months;
}

export function parseJWT(token) {
  let base64Url = token.split('.')[1];
  let base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
  let jsonPayload = decodeURIComponent(window.atob(base64).split('').map((c) => 
      '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2)
  ).join(''));
  return JSON.parse(jsonPayload);
}
