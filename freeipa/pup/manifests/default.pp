node default {
  file{"/tmp/vagrant.puppet.test":content=>"Vagrant Puppet provisioner worked\n"}
  package{
    ['mc','wget','psmisc','net-tools']:
    ensure=>present
  }

  include freeipa
}

class freeipa {
  ## https://www.digitalocean.com/community/tutorials/how-to-set-up-centralized-linux-authentication-with-freeipa-on-centos-7

  ## check hostname setting
  if ( $domain != $ipa_domain ) {
    fail("facter domain mismatch $domain != $ipa_domain")
  }
  host{$fqdn: ip=>"${ipaddress}",host_aliases=>[$hostname]}

  include freeipa::rng
  include freeipa::server
}

class freeipa::rng {
  package {['rng-tools']:ensure=>present}
  service{'rngd':ensure=>running,enable=>true}
}

class freeipa::server {
  package{'chrony':ensure=>absent,before=>Package['ipa-server','ntp']}
  package {['ipa-server','ntp']:ensure=>present}
}
