#!/bin/bash
source /home/fileserver/Applications/ArchServer/config/passwords.sh

HOSTNAME=timoverbrugghe
API=$duckdnsapi

echo url="https://www.duckdns.org/update?domains=\"$HOSTNAME\"&token=\"$API\"&ip=" | curl -k -o /home/fileserver/Applications/duckdns/duck.log -K -