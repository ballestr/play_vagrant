#!/bin/bash

user=$(id -u -n)
if [ "$user" != "vagrant" ]; then
	echo "## Check Kibana accessible from host:"
	curl -s -X GET 'http://localhost:5601'
	echo

	host=elk0
	echo "## copy and remote exec this script $0 on $host"
	vagrant rsync
	vagrant ssh $host -c /vagrant/check_elk.sh
	exit
fi

echo "## Check hostname"
hostname -f

echo "## Check ElasticSearch running"
curl -s -X GET 'http://localhost:9200'

echo "## Check Kibana running"
curl -s -X GET 'http://localhost:5601'
echo ## newline

echo "## Test that Elastic gets the filebeat entries"
curl -s -XGET 'http://localhost:9200/filebeat-*/_search?pretty' | egrep '@timestamp|logsource'

echo "## guest time"
date 
