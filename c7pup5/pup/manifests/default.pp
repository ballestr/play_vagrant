node default {
  file{"/tmp/vagrant.puppet.test":content=>"Vagrant Puppet provisioner worked\n"}
  package{"mc":ensure=>present}
}
