# RH postgresql is 9.2, too old
# yum install postgresql postgresql-server
# postgresql-setup initdb

## from https://www.postgresql.org/download/linux/redhat/
yum install -y https://download.postgresql.org/pub/repos/yum/9.4/redhat/rhel-7-x86_64/pgdg-redhat94-9.4-2.noarch.rpm
yum install -y postgresql94 postgresql94-server postgresql94-devel 
/usr/pgsql-9.4/bin/postgresql94-setup initdb
systemctl enable postgresql-9.4
systemctl start postgresql-9.4

yum install nginx

yum install epel-release

yum install python34 python34-pip 
yum install -y python34-devel libxml2-devel  libffi-devel graphviz 
# RH equivalents of libpq-devel libssl-devel  libxslt1-devel
yum install -y libxslt-devel openssl-devel 

pip3 install gunicorn
yum install supervisor
yum install git

./bootstrap_common.sh
