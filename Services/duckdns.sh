API=

echo url="https://www.duckdns.org/update?domains=timoverbrugghe&token=\"$API\"&ip=" | curl -k -o /home/fileserver/Applications/duckdns/duck.log -K -