#!/bin/bash
#puppet_setup.sh

VER='3.8.7-1.el7'

sudo cp puppet5.repo /etc/yum.repos.d/

function yumi() {
    rpm -q $1 || yum install -q -y $1
}
yumi epel-release
yumi puppet5-release
yumi puppet-agent
#rpm -q puppet-release || yum install -y https://yum.puppetlabs.com/puppet-release-el-7.noarch.rpm
#rpm -q puppet || sudo yum install -y --disablerepo puppet puppet-${VER}
