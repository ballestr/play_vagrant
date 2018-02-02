
- https://github.com/Yelp/elastalert
- https://engineeringblog.yelp.com/2015/10/elastalert-alerting-at-scale-with-elasticsearch.html
- https://elastalert.readthedocs.io/en/latest/running_elastalert.html


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

