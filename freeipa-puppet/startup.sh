#!/bin/bash
rpm -Uvh https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
sudo yum install puppet -y
sudo /opt/puppetlabs/bin/puppet module install adullact-freeipa
