# phpIPAM
a web IP address management application (IPAM)
- https://phpipam.net/
- https://phpipam.net/news/phpipam-installation-on-centos-7/

Nice that it supports PowerDNS. The rest seems less flexible than NetBox

## Manual steps:
### mysql
```
mysql_secure_installation
```
need to setup a password on mysql root@localhost

### phpIPAM
- Connect to http://localhost:8001/phpipam/
- Choose new phpipam installation

### backup
Backing up the data under `/var/www/html/db` feels like a pretty bad idea... why do they suggest that?
```
mkdir -p /var/backup
/usr/bin/mysqldump -u phpipam -pphpipamadmin phpipam > /var/backup/phpipam.mysql
```

## misc
- pull config from VM
vagrant scp machine1:/var/www/html/phpipam/config.php ansible/files/
