#!/bin/bash
#puppet_setup.sh

VER='3.8.7-1.el7'

sudo cp puppet3.repo /etc/yum.repos.d/
rpm -q epel-release || yum install -y epel-release
rpm -q puppet-release || yum install -y https://yum.puppetlabs.com/puppet-release-el-7.noarch.rpm
#rpm -q puppet || sudo yum install -y --disablerepo puppet puppet-${VER}
rpm -q puppet-agent || yum install puppet-agent
