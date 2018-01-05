# Core network services
- Ganglia for perf stats on local VMs

## Ganglia
Will it gmond collector work with multicast on eth1 ?

Connect to http://localhost:8101/ganglia/

## vagrant-scp
For copying files from the VM.
https://github.com/invernizzi/vagrant-scp
```
vagrant plugin install vagrant-scp
vagrant scp core01:/etc/ganglia/gmond.conf ansible/files/
vagrant scp core01:/etc/ganglia/gmetad.conf ansible/files/
vagrant scp core01:/etc/httpd/conf.d/ganglia.conf ansible/files/
```
