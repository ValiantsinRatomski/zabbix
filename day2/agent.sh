#!/bin/bash

sudo su

setenforce 0
systemctl stop firewalld

yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y

yum install zabbix-agent -y
systemctl start zabbix-agent


#-----
#  PASSIVE
#-----
sed -i 's/Server=127.0.0.1/Server=${srv_ip}/' /etc/zabbix/zabbix_agentd.conf


#-----
#  ACTIVE
#-----
sed -i 's/ServerActive=127.0.0.1/ServerActive=${srv_ip}/' /etc/zabbix/zabbix_agentd.conf
echo -e 'ServerPort=10051' >> /etc/zabbix/zabbix_agentd.conf
systemctl restart zabbix-agent

#-----------------AUTO AGENT--------------------------------------
#sed -i 's/Hostname=Zabbix server/Hostname=Tomcat/' /etc/zabbix/zabbix_agentd.conf
#echo 'HostMetadataItem=system.uname' >> /etc/zabbix/zabbix_agentd.conf
#systemctl restart zabbix-agent
#-----------------------------------------------------------------

