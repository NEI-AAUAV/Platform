-- Remove old device logins
DELETE FROM nei.device_login WHERE expires_at < now();
