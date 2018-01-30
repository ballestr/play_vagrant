#!/bin/bash
## original from https://github.com/ryanmerolle/netbox-vagrant
## Port to Centos7, sergio.ballestrero@protonmail.com, January 2018
## Extracted irreducible shell bits

cd /tmp # anywhere but /root

printf "Step 4 of 20: Setup Postgres with netbox user, database, & permissions."
sudo -u postgres psql -c "CREATE DATABASE netbox"
sudo -u postgres psql -c "CREATE USER netbox WITH PASSWORD 'J5brHrAXFLQSif0K'"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE netbox TO netbox"

# Update configuration.py with netbox generated SECRET_KEY, & Allowed Hosts
SECRET_KEY=$( python3 /opt/netbox/netbox/generate_secret_key.py )
sed -i "s~SECRET_KEY = ''~SECRET_KEY = '$SECRET_KEY'~g" /opt/netbox/netbox/netbox/configuration.py
# Clear SECRET_KEY variable
unset SECRET_KEY


# Install the database schema
printf "Step 16 of 20: Install the database schema...\n"
python3 /opt/netbox/netbox/manage.py migrate || exit 1

# Create admin / admin superuser
printf "Step 17 of 20: Create NetBox superuser...\n"
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'admin')" \
 | python3 /opt/netbox/netbox/manage.py shell --plain

# Collect Static Files
printf "Step 18 of 20: collectstatic\n"
python3 /opt/netbox/netbox/manage.py collectstatic --no-input <<<yes

# Load Initial Data (Optional) Comment out if you like
printf "Step 19 of 20: Load intial data.\n"
python3 /opt/netbox/netbox/manage.py loaddata initial_data

## lazy way to make this "idempotent" for Ansible
touch /opt/netbox-setup.done
