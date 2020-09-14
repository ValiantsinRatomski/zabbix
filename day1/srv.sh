#!/bin/bash

sudo su

setenforce 0
systemctl stop firewalld

yum install mariadb mariadb-server -y
/usr/bin/mysql_install_db --user=mysql
systemctl start mariadb
mysql -uroot <<EOF
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by 'P@ssw0rd';quit;
EOF


yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y


yum install zabbix-server-mysql zabbix-web-mysql -y
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix --password=P@ssw0rd zabbix 
echo -e 'DBHost=localhost\nDBPassword=P@ssw0rd' >> /etc/zabbix/zabbix_server.conf
systemctl start zabbix-server



sed -i 's@# php_value date.timezone Europe/Riga@php_value date.timezone Europe/Minsk@' /etc/httpd/conf.d/zabbix.conf
systemctl start httpd



