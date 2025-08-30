#!/bin/sh
#Copy default config file if user config is unavailable
if [ ! -f "/etc/mopidy/mopidy.conf" ]
then
    cp /etc/default/mopidy.conf  /etc/mopidy/mopidy.conf
fi
# Read the hostname from the configuration file
jfconf=$(grep -A5 "\[jellyfin\]" "/etc/mopidy/mopidy.conf")
jfhost=$(echo "$jfconf" | awk -F' *= *' '/^hostname/ {print $2}')
#Wait for jellyfin http port 8096 to open
while ! curl -sSf "${jfhost}" >/dev/null 2>&1; do
    echo "Waiting for host ${jfhost} to become accessible..."
    sleep 5
done
sleep 2
#Start mopidy
mopidy --config /etc/mopidy/mopidy.conf
