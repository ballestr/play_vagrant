# NetBox on Centos7

Shamelessly copied from https://github.com/ryanmerolle/netbox-vagrant

- https://github.com/digitalocean/netbox
- http://netbox.readthedocs.io/en/stable/
- https://github.com/digitalocean/netbox/wiki/Frequently-Asked-Questions

# Interesting Settings in NebBox

- Enforce login, otherwise view is public:  
  - http://netbox.readthedocs.io/en/latest/configuration/optional-settings/#login_required
- Napalm integration - bookmarking for later https://napalm-automation.net/
  - http://netbox.readthedocs.io/en/latest/configuration/optional-settings/#napalm_username


# ToDo:
Before going in production:
- [ ] figure out backups
- [ ] change MEDIA_ROOT
- [ ] nginx unused port 80
- [ ] change port from 8001, to use more restrictive SElinux setting
- [ ] review security+SElinux of supervisord, gunicorn, postgresql94

# Install notes

### PostgreSQL auth
` django.db.utils.OperationalError: FATAL:  Ident authentication failed for user "netbox" `
- https://www.depesz.com/2007/10/04/ident/

Change pg_hba to fix it.

### PostgreSQL >=9.4
RHEL7 ships PostgreSQL 9.2 . Take RPMs from upstream instead:
- https://github.com/digitalocean/netbox/blob/v2.2.8/docs/installation/postgresql.md
- https://www.postgresql.org/download/linux/redhat/

Unfortunately the upstream PostgreSQL 9.4 seems to run in SELinux unconfined.

### Supervisord 
```
[root@netbox supervisord.d]# supervisord -n 
/usr/lib/python2.7/site-packages/supervisor/options.py:296: UserWarning: Supervisord is running as root and it is searching for its configuration file in default locations (including its current working directory); you probably want to specify a "-c" argument specifying an absolute path to a configuration file for improved security.
  'Supervisord is running as root and it is searching '
Error: Invalid user name www-data
For help, use /bin/supervisord -h
```
Change to user `nginx`:
```
[root@netbox supervisord.d]# cat netbox.ini 
[program:netbox]
command = gunicorn -c /opt/netbox/gunicorn_config.py netbox.wsgi
directory = /opt/netbox/netbox/
user = nginx
```
Still breaks:
```
2018-01-28 09:04:57,131 CRIT Supervisor running as root (no user in config file)
2018-01-28 09:04:57,132 WARN Included extra file "/etc/supervisord.d/netbox.ini" during parsing
2018-01-28 09:04:57,252 INFO RPC interface 'supervisor' initialized
2018-01-28 09:04:57,253 CRIT Server 'unix_http_server' running without any HTTP authentication checking
2018-01-28 09:04:57,255 INFO supervisord started with pid 6907
2018-01-28 09:04:58,281 INFO spawned: 'netbox' with pid 6910
2018-01-28 09:04:58,967 INFO exited: netbox (exit status 1; not expected)
2018-01-28 09:04:59,995 INFO spawned: 'netbox' with pid 6912
2018-01-28 09:05:00,639 INFO exited: netbox (exit status 1; not expected)
2018-01-28 09:05:02,666 INFO spawned: 'netbox' with pid 6913
2018-01-28 09:05:03,393 INFO exited: netbox (exit status 1; not expected)
2018-01-28 09:05:06,500 INFO spawned: 'netbox' with pid 6914
2018-01-28 09:05:07,405 INFO exited: netbox (exit status 1; not expected)
2018-01-28 09:05:08,410 INFO gave up: netbox entered FATAL state, too many start retries too quickly
^C2018-01-28 09:05:19,679 WARN received SIGINT indicating exit request
```

```
[root@netbox supervisord.d]# gunicorn -c /opt/netbox/gunicorn_config.py netbox.wsgi
Invalid value for user: www-data
[root@netbox supervisord.d]# cat /opt/netbox/gunicorn_config.py 
command = '/usr/bin/gunicorn'
pythonpath = '/opt/netbox/netbox'
bind = '127.0.0.1:8001'
workers = 3
user = 'nginx'
```

Not sure if running as `nginx` is the right thing to do anyway... we'll see later.

### nginx
`/etc/nginx/nginx.conf` already includes a default server for port 80.
As a quick workaround, use port 8080 for proxiyng gunicorn / netbox.

```
[root@netbox sites-available]# nginx -T
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
...
# configuration file /etc/nginx/conf.d/sites-enabled.conf:
include /etc/nginx/sites-enabled/*.conf;

# configuration file /etc/nginx/sites-enabled/netbox.conf:
server {
    listen 8080;
...
```

### SElinux
nginx runs in `httpd` context:
```
[root@netbox nginx]# ps -Zx | grep nginx
system_u:system_r:httpd_t:s0     2366 ?        Ss     0:00 nginx: master process /usr/sbin/nginx
```
We can use the booleans :
```
[root@netbox nginx]# getsebool -a | grep httpd | egrep 'connect|network'
httpd_can_connect_ftp --> off
httpd_can_connect_ldap --> off
httpd_can_connect_mythtv --> off
httpd_can_connect_zabbix --> off
httpd_can_network_connect --> on
httpd_can_network_connect_cobbler --> off
httpd_can_network_connect_db --> off
httpd_can_network_memcache --> off
httpd_can_network_relay --> on
```
See https://danwalsh.livejournal.com/64779.html for how to get port lists corresponding to booleans.

`setsebool httpd_can_network_relay=1` is not sufficient for port 8001, need `setsebool httpd_can_network_connect=1`.
We should pick another port, so we won't need to write a custom rule ;-) 

And we have a bunch of services that are running in unconfined ( = no protection ):
```
[root@netbox ~]# ps Zxau | grep "^system_u:system_r" | grep -v "kernel_t:" | grep unconfined
system_u:system_r:unconfined_service_t:s0 postgres 826 0.0  1.5 239456 15304 ? S    09:43   0:01 /usr/pgsql-9.4/bin/postgres -D /var/lib/pgsql/9.4/data
system_u:system_r:unconfined_service_t:s0 postgres 836 0.0  0.1 94604 1428 ?   Ss   09:43   0:00 postgres: logger process   
system_u:system_r:unconfined_service_t:s0 postgres 844 0.0  0.3 239580 3612 ?  Ss   09:43   0:00 postgres: checkpointer process   
system_u:system_r:unconfined_service_t:s0 postgres 845 0.0  0.2 239456 2756 ?  Ss   09:43   0:00 postgres: writer process   
system_u:system_r:unconfined_service_t:s0 postgres 847 0.0  0.1 239456 1696 ?  Ss   09:43   0:00 postgres: wal writer process   
system_u:system_r:unconfined_service_t:s0 postgres 848 0.0  0.2 239868 2660 ?  Ss   09:43   0:00 postgres: autovacuum launcher process   
system_u:system_r:unconfined_service_t:s0 postgres 849 0.0  0.1 94864 1924 ?   Ss   09:43   0:00 postgres: stats collector process   
system_u:system_r:unconfined_service_t:s0 root 2390 0.0  1.1 121176 12004 ?    Ss   09:51   0:01 /usr/bin/python /usr/bin/supervisord -c /etc/supervisord.conf
system_u:system_r:unconfined_service_t:s0 nginx 2391 0.0  1.7 118560 17540 ?   S    09:51   0:01 /usr/bin/python3.4 /usr/bin/gunicorn -c /opt/netbox/gunicorn_config.py netbox.wsgi
system_u:system_r:unconfined_service_t:s0 nginx 2394 0.3  7.8 322260 79324 ?   S    09:51   0:08 /usr/bin/python3.4 /usr/bin/gunicorn -c /opt/netbox/gunicorn_config.py netbox.wsgi
system_u:system_r:unconfined_service_t:s0 nginx 2395 0.4  8.2 326504 83664 ?   S    09:51   0:08 /usr/bin/python3.4 /usr/bin/gunicorn -c /opt/netbox/gunicorn_config.py netbox.wsgi
system_u:system_r:unconfined_service_t:s0 nginx 2396 0.3  7.8 322028 79292 ?   S    09:51   0:07 /usr/bin/python3.4 /usr/bin/gunicorn -c /opt/netbox/gunicorn_config.py netbox.wsgi
```

## Image upload permissions
```
[Errno 13] Permission denied: '/opt/netbox/netbox/media/image-attachments/site_1_Crew.jpg'
```
Changing permissions is sufficient:
```
[root@netbox ~]# chgrp -R nginx /opt/netbox/netbox/media/
[root@netbox ~]# chmod -R g+rwx /opt/netbox/netbox/media/
```
which confirms that gunicorn runs in unconfined :-(

