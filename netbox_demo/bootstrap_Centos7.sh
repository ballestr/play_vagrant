#!/bin/bash
## Install packages for NetBox on Centos7
## split from original bootstrap.sh, from https://github.com/ryanmerolle/netbox-vagrant
## Port to Centos7, sergio.ballestrero@protonmail.com, January 2018

NS=05 

echo "## Prep 00/$NS: Updating CentOS7, be patient..."
yum install -q -y yum-plugin-fastestmirror deltarpm ## just in case they are not there yet
yum update -q -y

echo "## Prep 01/$NS Install EPEL & Tools"
## first and separately, EPEL repo definition for nginx, python34 and others
yum install -q -y epel-release
## sysadmin tools
yum install -q -y mc net-tools psmisc strace telnet tcpdump htop

echo "## Prep 02/$NS: Install and start PostgreSQL 9.4"
## NetBox >=2.0 needs Postgresql 9.4, RHEL7 has 9.2 only
# yum install postgresql postgresql-server
# postgresql-setup initdb
## from https://www.postgresql.org/download/linux/redhat/
yum install -q -y https://download.postgresql.org/pub/repos/yum/9.4/redhat/rhel-7-x86_64/pgdg-redhat94-9.4-3.noarch.rpm
yum install -q -y postgresql94 postgresql94-server postgresql94-devel
## init database
/usr/pgsql-9.4/bin/postgresql94-setup initdb
## fix ident auth mess
PGDATA=/var/lib/pgsql/9.4/data/
[ -e $PGDATA/pg_hba.conf.orig ] || mv -v $PGDATA/pg_hba.conf $PGDATA/pg_hba.conf.orig 
cp -vaf /vagrant/config_files_Centos7/pg_hba.conf $PGDATA/
## start service
systemctl enable postgresql-9.4
systemctl start postgresql-9.4

## Servers
echo "## Prep 03/$NS: Install daemons"
yum install -q -y git nginx supervisor

## Python3, PIP and build dependencies
echo "## Prep 04/$NS: Install python36 + PIP with build dependencies"
yum install -q -y python36 python36-pip python36-devel libxml2-devel libxslt-devel openssl-devel  libffi-devel graphviz

echo "## Prep 05/$NS: Pre-configuration"
## for nginx on Centos7, to be more like ubuntu
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled
echo "include /etc/nginx/sites-enabled/*.conf;" > /etc/nginx/conf.d/sites-enabled.conf
## supervisord also needs the file to be called .ini
#mkdir -p /etc/supervisor
#ln -snf /etc/supervisord.d /etc/supervisor/conf.d

systemctl daemon-reload
systemctl enable --now nginx
systemctl enable --now supervisord

## SELinux allow port 8001 - and all others. We should change port...
setsebool -P httpd_can_network_connect=1
