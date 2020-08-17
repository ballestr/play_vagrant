#!/bin/bash
#puppet_setup.sh

rpm -q epel-release || yum install -y epel-release

#VER='3.8.7-1.el7'
#sudo cp puppet3.repo /etc/yum.repos.d/
#rpm -q puppet || sudo yum install -y --disablerepo puppet puppet-${VER}

## get latest Puppet 6
rpm -q puppet-release || yum install -y https://yum.puppetlabs.com/puppet-release-el-7.noarch.rpm
rpm -q puppet-agent || yum install -y puppet-agent
