# Notes on Vagrant in general

## Vagrant update
```
vagrant box update
vagrant destroy
vagrant up --no-provision 
vagrant ssh -c "yum update -y"
vagrant halt
vagrant up --provision
```

## plugins

## vagrant-vbguest
Automate VirtualBox Guest Plugin, avoid clock drift
- https://github.com/dotless-de/vagrant-vbguest

## vagrant-scp
For copying files to/from the VM.
- https://github.com/invernizzi/vagrant-scp

```
vagrant plugin install vagrant-scp
vagrant scp core01:/etc/ganglia/gmond.conf ansible/files/
vagrant scp core01:/etc/ganglia/gmetad.conf ansible/files/
vagrant scp core01:/etc/httpd/conf.d/ganglia.conf ansible/files/
```
