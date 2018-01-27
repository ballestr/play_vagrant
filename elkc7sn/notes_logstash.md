# notes_logstash

## Filebeat
- https://www.elastic.co/guide/en/beats/filebeat/5.6/index.html

```
[root@elk0 filebeat]# filebeat.sh -configtest -e
2018/01/26 09:49:00.939340 beat.go:297: INFO Home path: [/usr/share/filebeat] Config path: [/etc/filebeat] Data path: [/var/lib/filebeat] Logs path: [/var/log/filebeat]
2018/01/26 09:49:00.939807 beat.go:192: INFO Setup Beat: filebeat; Version: 5.6.6
2018/01/26 09:49:00.940303 logstash.go:91: INFO Max Retries set to: 3
2018/01/26 09:49:00.940550 metrics.go:23: INFO Metrics logging every 30s
2018/01/26 09:49:00.941451 outputs.go:108: INFO Activated logstash as output plugin.
2018/01/26 09:49:00.942005 publish.go:300: INFO Publisher name: elk0
2018/01/26 09:49:00.943452 async.go:63: INFO Flush Interval set to: 1s
2018/01/26 09:49:00.943538 async.go:64: INFO Max Bulk Size set to: 1024
Config OK

[root@elk0 filebeat]# cat /var/lib/filebeat/registry 
[{"source":"/var/log/secure","offset":66761,"FileStateOS":{"inode":33902214,"device":64768},"timestamp":"2018-01-26T09:32:02.897700038Z","ttl":-1},{"source":"/var/log/messages","offset":380928,"FileStateOS":{"inode":33902213,"device":64768},"timestamp":"2018-01-26T09:48:54.403567457Z","ttl":-1}]

```

```
[root@elk0 filebeat]# cp filebeat.yml test.yml 
[root@elk0 filebeat]# filebeat.sh -once  -c test.yml
```

```
cp /var/log/secure /root/secure.log
cat secure.log | filebeat.sh -e -v  -c test_stdout.yml 
```

```
# cat secure.log | filebeat.sh -e -v  -c test_stdout.yml
...
  "message": "Jan 26 11:11:11 elk0 test: end_of_test_log",
  "offset": 0,
  "source": "",
  "type": "syslog"
}
2018/01/26 10:34:31.064494 sync.go:96: DBG  473 events out of 473 events sent to logstash host 127.0.0.1:5044:10200. Continue sending
2018/01/26 10:34:31.064711 single.go:150: DBG  send completed
...
^C
...
2018/01/26 10:35:14.269584 beat.go:237: INFO filebeat stopped.
```
## get back the test configs
```
$ vagrant scp elk0:/etc/filebeat/test_*.yml ./files/
```

