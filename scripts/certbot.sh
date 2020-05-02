#!/bin/bash

## Certbot renewal script - Renews Let's Encrypt certificates and transforms it in the right format for Unifi & Plexmediaserver

## Certbot Let's Encrypt renewal
certbot renew --agree-tos --webroot -w /home/fileserver/Media/Network/

## PlexMediaServer certificate creation
# Create PKCS12 certificate
openssl pkcs12 -export -in /etc/letsencrypt/live/timoverbrugghe.duckdns.org/fullchain.pem -inkey /etc/letsencrypt/live/timoverbrugghe.duckdns.org/privkey.pem -out /home/fileserver/Applications/plexmediaserver/certificate.pfx -passout pass:plexmediaserver

# Apply correct permission to PKCS12 certificate
chown fileserver:fileserver /home/fileserver/Applications/plexmediaserver/certificate.pfx
chmod 644 /home/fileserver/Applications/plexmediaserver/certificate.pfx

# Reload Apache & Unifi service after renewing certificates (plexmediaserver does not need to be restarted)
# systemctl restart unifi httpd
systemctl restart httpd