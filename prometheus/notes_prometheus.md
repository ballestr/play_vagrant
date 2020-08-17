# Prometheus
- https://prometheus.io/
- RPMs: https://github.com/lest/prometheus-rpm

```
yum install prometheus2
yum install node_exporter
yum install https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-5.0.1-1.x86_64.rpm 
```

```
service start prometheus
service start node_exporter
service grafana-server start
service chronyd start
```

## bad timekeeping in virtualbox
> Warning! Detected 464.66 seconds time difference between your browser and the server. Prometheus relies on accurate time and time drift might cause unexpected query results.

## Grafana
- publish to Prometheus: http://docs.grafana.org/administration/metrics/



## InfluxDB
Using InfluxDB for long-term storage ?

Only single system is OpenSource, Cluster is payware

- https://docs.influxdata.com/influxdb/v1.5/supported_protocols/prometheus/
- https://docs.influxdata.com/influxdb/v1.5/guides/hardware_sizing/
