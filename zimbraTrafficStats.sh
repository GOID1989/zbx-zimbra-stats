#!/bin/bash

function get_bytes(){
    # trim
    rec="$(echo -e $1 | tr -d '[:space:]')"
    last_char=${rec: -1}

    if [ "$last_char" = "k" ]; then
        bytes="$(echo -e $1 | tr -d 'k')"
        bytes=$(($bytes * 1024))
        echo $bytes
    elif [ "$last_char" = "m" ]; then
        bytes="$(echo -e $1 | tr -d 'm')"
        bytes=$(($bytes * 1024 * 1024))
        echo $bytes
    fi
}

case "$1" in
    total_received)
        /opt/zimbra/common/bin/pflogsumm.pl -d yesterday /var/log/mail.log --detail 0 | grep -m 1 -o -P '(?<= ).*(?=received)'| sed -e 's/^\s*//' -e '/^$/d'
    ;;
    total_delivered)
        /opt/zimbra/common/bin/pflogsumm.pl -d yesterday /var/log/mail.log --detail 0 | grep -m 1 -o -P '(?<= ).*(?=delivered)'| sed -e 's/^\s*//' -e '/^$/d'
    ;;
    total_bdelivered)
	delivered=$(/opt/zimbra/common/bin/pflogsumm.pl -d yesterday /var/log/mail.log --detail 0 | grep -m 1 -o -P '(?<= ).*(?=bytes delivered)'| sed -e 's/^\s*//' -e '/^$/d')
	get_bytes $delivered
    ;;
    total_breceived)
	received=$(/opt/zimbra/common/bin/pflogsumm.pl -d yesterday /var/log/mail.log --detail 0 | grep -m 1 -o -P '(?<= ).*(?=bytes received)'| sed -e 's/^\s*//' -e '/^$/d')
	get_bytes $received
    ;;
    received|delivered|forwarded|deferred|bounced|rejected)
        /opt/zimbra/common/bin/pflogsumm.pl -d today /var/log/mail.log --detail 0 | grep -m 1 -o -P '(?<= ).*(?='$1')'| sed -e 's/^\s*//' -e '/^$/d'
    ;;
    breceived)
        received=$(/opt/zimbra/common/bin/pflogsumm.pl -d today /var/log/mail.log --detail 0 | grep -m 1 -o -P '(?<= ).*(?=bytes received)'| sed -e 's/^\s*//' -e '/^$/d')
	get_bytes $received
    ;;
    bdelivered)
        delivered=$(/opt/zimbra/common/bin/pflogsumm.pl -d today /var/log/mail.log --detail 0 | grep -m 1 -o -P '(?<= ).*(?=bytes delivered)'| sed -e 's/^\s*//' -e '/^$/d')
        get_bytes $delivered
    ;;
esac
