# ElastAlert
- https://github.com/Yelp/elastalert
- https://engineeringblog.yelp.com/2015/10/elastalert-alerting-at-scale-with-elasticsearch.html
- https://elastalert.readthedocs.io/en/latest/running_elastalert.html

An API for ElastAlert ?
- https://github.com/mjflve/elastalert-server


## Manual setup
```
[root@elk0 ~]# elastalert-create-index --config config.yaml
Elastic Version:5
Mapping used for string:{'index': 'not_analyzed', 'type': 'string'}
New index elastalert_status created
Done!

[root@elk0 ~]# elastalert-create-index --config config.yaml
Elastic Version:5
Mapping used for string:{'index': 'not_analyzed', 'type': 'string'}
Index elastalert_status already exists. Skipping index creation.
```

```
[root@elk0 ~]# curl http://localhost:9200/elastalert_status/_settings?pretty
{
  "elastalert_status" : {
    "settings" : {
      "index" : {
        "creation_date" : "1517401147174",
        "number_of_shards" : "5",
        "number_of_replicas" : "1",
        "uuid" : "K62MytDUQnSyAi5u0PZ78w",
        "version" : {
          "created" : "5060799"
        },
        "provided_name" : "elastalert_status"
      }
    }
  }
}
```
Could be used to check whether elastalert-create-index needs to be executed.

## Testing a rule
```
[root@elk0 ~]# elastalert-test-rule elastalert/example_rules/example_frequency.yaml
Successfully loaded Example frequency rule

INFO:elastalert:Note: In debug mode, alerts will be logged to console but NOT actually sent.
                To send them but remain verbose, use --verbose instead.
INFO:elastalert:Queried rule Example frequency rule from 2018-01-30 12:21 UTC to 2018-01-30 12:36 UTC: 0 / 0 hits
INFO:elastalert:Queried rule Example frequency rule from 2018-01-30 12:36 UTC to 2018-01-30 12:51 UTC: 0 / 0 hits
...
INFO:elastalert:Queried rule Example frequency rule from 2018-01-31 11:51 UTC to 2018-01-31 12:06 UTC: 0 / 0 hits
INFO:elastalert:Queried rule Example frequency rule from 2018-01-31 12:06 UTC to 2018-01-31 12:21 UTC: 0 / 0 hits

Would have written the following documents to writeback index (default is elastalert_status):

elastalert_status - {'hits': 0, 'matches': 0, '@timestamp': datetime.datetime(2018, 1, 31, 12, 21, 47, 36859, tzinfo=tzutc()), 'rule_name': 'Example frequency rule', 'starttime': datetime.datetime(2018, 1, 30, 12, 21, 45, 786357, tzinfo=tzutc()), 'endtime': datetime.datetime(2018, 1, 31, 12, 21, 45, 786357, tzinfo=tzutc()), 'time_taken': 1.2363951206207275}
```

## systemd service
- https://github.com/Yelp/elastalert/issues/194
- https://serverfault.com/questions/736624/systemd-service-automatic-restart-after-startlimitinterval

```
[root@elk0 system]# systemctl restart elastalert.service
Job for elastalert.service failed because start of the service was attempted too often. See "systemctl status elastalert.service" and "journalctl -xe" for details.
To force a start use "systemctl reset-failed elastalert.service" followed by "systemctl start elastalert.service" again.
[root@elk0 system]# systemctl reset-failed elastalert.service
[root@elk0 system]# systemctl restart elastalert.service
```

```
[root@elk0 log]# cat /etc/systemd/system/elastalert.service 
## ElastAlert systemd service
## restart rate limiting
## https://serverfault.com/questions/736624/systemd-service-automatic-restart-after-startlimitinterval

[Unit]
Description=ElastAlert
After=multi-user.target
After=elasticsearch.service

[Service]
Type=simple
User=nobody
Group=nobody
WorkingDirectory=/var/tmp
ExecStart=/usr/bin/elastalert --verbose --config /etc/elastalert/config.yaml
Restart=on-failure
#Restart=always
StartLimitInterval=60
StartLimitBurst=3
KillSignal=SIGKILL
PIDFile=/var/run/elastalert.pid
StandardOutput=syslog
StandardError=syslog


[Install]
WantedBy=multi-user.target
```

## Ansible synchronize
Try to use that to tidy up `/etc/elasticstash` from unwanted files, like Puppet `tidy` . First result :-( 
```
[root@elk0 system]# ls -la /etc/elastalert/
total 24
drwxr-xr-x.  3  503 games   55 Feb  2  2018 .
drwxr-xr-x. 90 root root  8192 Feb  1 07:51 ..
-rw-r--r--.  1  503 games 2093 Feb  2  2018 config.yaml
-rw-r--r--.  1 root root  6148 Feb  2  2018 .DS_Store
drwxr-xr-x.  2  503 games   33 Feb  2  2018 rules
```
Now someone come and tell me that Puppet is verbose, just try it.
```
  ## try to use rsync --delete to cleanup unwanted local files - sergio, Feb 2018
  - name: elastalert configuration
    synchronize:
      dest: /etc/elastalert/
      src: elastalert/
      mode: push # just to be clear
      delete: yes
      archive: yes 
      owner: no # ansible crap - avoid wrong user/group
      group: no # ansible crap - avoid wrong user/group
      rsync_opts:
        - "--exclude=.DS_Store" # mac crap
  ## make sure rsync or root didn't mess up ownership
  - name: elastalert configuration owner
    file:
      dest: /etc/elastalert/
      state: directory
      owner: root
      group: root
      mode: a=rX,u+w  # 644 doesn't work for directories
      recurse: yes
```
