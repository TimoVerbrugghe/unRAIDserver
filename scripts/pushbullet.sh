#!/bin/bash
source /home/fileserver/Applications/ArchServer/config/passwords.sh

API=$pushbulletapi
TITLE="$1"
MSG="$2"

curl -u $API: https://api.pushbullet.com/v2/pushes -d type=note -d title="$TITLE" -d body="$MSG"
