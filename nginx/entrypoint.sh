#!/bin/sh

# Get certs
# certbot certonly -n -d nei-aauav.pt,www.nei-aauav.pt \
#   --standalone --preferred-challenges http --email nei@aauav.pt --agree-tos --expand

# Kick off cron
# /usr/sbin/crond -f -d 8 &

# Start nginx
/usr/sbin/nginx -g "daemon off;"
