node default {
class {'freeipa':
    ipa_role                    => 'master',
    domain                      => 'ipa.example',
    ipa_master_fqdn             => 'server.ipa.example',
    puppet_admin_password       => 'Password',
    directory_services_password => 'Password',
    install_ipa_server          => true,
    ip_address                  => 'IP',
    enable_ip_address           => true,
    enable_hostname             => true,
    manage_host_entry           => true,
    install_epel                => true,
    humanadmins                 => {
      log_ldap => {
        ensure => 'present',
        password => 'SuperLdap',
      },
    },
}
}
