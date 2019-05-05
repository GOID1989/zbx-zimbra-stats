#!/bin/bash

# Read statistics data from Zimbra. Write to temp file
/opt/zimbra/bin/zmsoap -z -t admin GetServerStatsRequest > /tmp/zimbraStats.xml

# Empty sending list
> /tmp/zabbix_send.lst
while read line
do
    key=$(echo $line | awk -F "\"" '{print "zimbra."$2}')
    value=$(echo $line | grep -o -P '(?<=>).*(?=</stat>)' | sed -r 's/[,]/./g')

    # Check is the string contains value and valid
    if [ "$value" != "" ]
    then
	echo "\"$1\" $key $value" >> /tmp/zabbix_send.lst
    fi
done </tmp/zimbraStats.xml

/usr/bin/zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -i /tmp/zabbix_send.lst
