export function monthsPassed(date) {
  const today = new Date();
  let months = (today.getFullYear() - date.getFullYear()) * 12;
  months -= date.getMonth();
  months += today.getMonth();
  return months;
}

export function parseJWT(token) {
  if (!token || typeof token !== 'string') {
    throw new Error('Invalid token');
  }
  
  const parts = token.split('.');
  if (parts.length !== 3) {
    throw new Error('Invalid JWT format');
  }
  
  try {
    let base64Url = parts[1];
    let base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    
    // Add padding if needed
    while (base64.length % 4) {
      base64 += '=';
    }
    
    const decoded = window.atob(base64);
    let jsonPayload = decodeURIComponent(decoded.split('').map((c) => 
        '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2)
    ).join(''));
    
    return JSON.parse(jsonPayload);
  } catch (error) {
    throw new Error('Failed to parse JWT: ' + error.message);
  }
}
