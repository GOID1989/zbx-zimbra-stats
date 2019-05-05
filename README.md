# zbx-zimbra-stats
Zabbix Template and script for monitoring Zimbra statistics (traffic and stats)

## Template

Uses two scripts to populate item:  

 * zimbraTrafficStats.sh - Script using /opt/zimbra/common/bin/pflogsumm.pl
 * zimbraGetStats.sh - Script using /opt/zimbra/bin/zmsoap and zabbix_sender
    

## Scripts

Grabs info from these providers (Zimbra related tools):  

 * /opt/zimbra/bin/zmsoap -z -t admin GetServerStatsRequest  
 * /opt/zimbra/common/bin/pflogsumm.pl
 
 ## Files
 
 * crontab.txt - cron configuration
 * userparameter_zimbra.traffic.conf - Zabbix UserParameter
 * zimbra_zabbix - sudo file for zabbix user
 
## Prerequisites

 * Zabbix Server that can process data being sent.
 * zabbix_agent(active) + zabbix_sender on the monitored host.
 
## Screens
![alt_text](https://github.com/GOID1989/zbx-zimbra-stats/blob/master/stats.png)
![alt_text](https://github.com/GOID1989/zbx-zimbra-stats/blob/master/traffic.png)

## HOWTO 

1. Import Template Zimbra Statistics.xml on the Zabbix Server.
2. Copy all files to the monitored host.
3. Copy userparameter file into the includes folder (Default: /etc/zabbix/zabbix_agentd.d/)
4. Copy the script files into your Zabbix folder (Default: /etc/zabbix)
   1. Make sure the scripts are executable.
   2. Optional: create a scripts directory inside /etc/zabbix/
5. Copy the zimbra_zabbix file into /etc/sudoers.d/
   1. Check permissions, they should be 0440
6. Add the line from crontab.txt to the end of the zimbra users crontab.
   1. Remember to change the hostname.

## Notes

To deploy via ansible using dj.wasabi's zabbix-agent role (https://galaxy.ansible.com/dj-wasabi/zabbix-agent)

1. Follow documentation for the role  
   1. Add the scripts to files/scripts/  
   2. Add userparameter files to templates/userparameters/
2. Add these tasks to playbook after the role has been run:


  		- hosts: all 
  			tasks:  
    		- name: Add sudoers file for the zabbix user  
      		copy:  
        		src: roles/dj-wasabi.zabbix-agent/files/sudo/zimbra_zabbix  
        		dest: /etc/sudoers.d/zimbra_zabbix  
        		mode: 0440  
        		validate: 'visudo -cf %s'  
      		become: yes  
    		- name: Add cron configuration for zimbraGetStats.sh  
      		cron:  
        		name: "Run ZimbraGetStats.sh every 1 min."  
        		user: zimbra  
        		job: /etc/zabbix/scripts/zimbra/zimbraGetStats.sh {{ ansible_fqdn }} >/dev/null 2>&1  
      		become: yes  
