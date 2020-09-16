#!/bin/bash

sudo su

setenforce 0
systemctl stop firewalld

yum install httpd -y
systemctl start httpd
systemctl enable httpd

yum install tomcat tomcat-webapps tomcat-admin-webapps -y
systemctl start tomcat
systemctl enable tomcat

chmod 777 /var/log/tomcat
chmod 777 /var/log/tomcat/*

#-----------------------------------
#		AGENT 
#-----------------------------------
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y

yum install zabbix-agent -y
systemctl start zabbix-agent


#----------------------------------------
#  PASSIVE
#----------------------------------------
sed -i 's/Server=127.0.0.1/Server=${srv_ip}/' /etc/zabbix/zabbix_agentd.conf
#-----
#  ACTIVE
#-----
sed -i 's/ServerActive=127.0.0.1/ServerActive=${srv_ip}/' /etc/zabbix/zabbix_agentd.conf
sed -i '/^Hostname/d' /etc/zabbix/zabbix_agentd.conf
echo 'Hostname=Tomcat' >> /etc/zabbix/zabbix_agentd.conf  # We should create host with the same name in web 			
systemctl restart zabbix-agent


