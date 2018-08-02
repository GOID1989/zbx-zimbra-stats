# zbx-zimbra-stats
Zabbix Template and script for moniroting Zimbra statistics (traffic and stats)

## Template
Uses two scripts to populate item:
 - zimbraTrafficStats.sh - UserParameter
 - zimbraGetStats.sh - cron and zabbix_sender

## Scripts
Grabs info from this providers (Zimbra related tools):
 - /opt/zimbra/bin/zmsoap -z -t admin GetServerStatsRequest
 - /opt/zimbra/common/bin/pflogsumm.pl
 
## Prerequisites
 - zabbix_sender
 - sudoers to /opt/zimbra/common/bin/pflogsumm.pl for zabbix user
 - replace {YOUR_HOSTAME_ON_ZABBIX} in zimbraGetStats.sh to YOURS env.