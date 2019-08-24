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

## Unifi keystore creation
# Create PKCS12 certificate
# openssl pkcs12 -export -in /etc/letsencrypt/live/timoverbrugghe.duckdns.org/fullchain.pem -inkey /etc/letsencrypt/live/timoverbrugghe.duckdns.org/privkey.pem -out /etc/letsencrypt/live/timoverbrugghe.duckdns.org/UnifiPKCS12.p12 -name UnifiPKCS12 -CAfile /etc/letsencrypt/live/timoverbrugghe.duckdns.org/chain.pem -caname UnifiPKCS12 -password pass:unifiarchserver

# Delete previously created keystore
# rm -f /etc/letsencrypt/live/timoverbrugghe.duckdns.org/keystore

# Covert PKCS12 certificate to a java keystore (aircontrolenterprise password is needed for unifi)
# keytool -importkeystore -srcstorepass unifiarchserver -deststorepass aircontrolenterprise -destkeypass aircontrolenterprise -srckeystore /etc/letsencrypt/live/timoverbrugghe.duckdns.org/UnifiPKCS12.p12 -srcstoretype PKCS12 -alias UnifiPKCS12 -keystore /etc/letsencrypt/live/timoverbrugghe.duckdns.org/keystore
# keytool -import -trustcacerts -alias unifi -deststorepass aircontrolenterprise -file /etc/letsencrypt/live/timoverbrugghe.duckdns.org/chain.pem -noprompt -keystore /etc/letsencrypt/live/timoverbrugghe.duckdns.org/keystore

# Backup old unifi keystore
# mv /var/lib/unifi/data/keystore /var/lib/unifi/data/keystore.bak

# Copy new unifi keystore
# cp /etc/letsencrypt/live/timoverbrugghe.duckdns.org/keystore /var/lib/unifi/data/keystore

# Reload Apache & Unifi service after renewing certificates (plexmediaserver does not need to be restarted)
# systemctl restart unifi httpd
systemctl restart httpd