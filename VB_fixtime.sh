#!/bin/bash
# fix timesync of existing VirtualBox VMs
# https://www.virtualbox.org/manual/ch09.html#changetimesync
# https://superuser.com/questions/463106/virtualbox-how-to-sync-host-and-guest-time

function fix {
VMNAME=$1
VBoxManage guestproperty set ${VMNAME} "/VirtualBox/GuestAdd/VBoxService/--timesync-interval" 10000
VBoxManage guestproperty set ${VMNAME} "/VirtualBox/GuestAdd/VBoxService/--timesync-min-adjust" 100
VBoxManage guestproperty set ${VMNAME} "/VirtualBox/GuestAdd/VBoxService/--timesync-set-on-restore" 1
VBoxManage guestproperty set ${VMNAME} "/VirtualBox/GuestAdd/VBoxService/--timesync-set-start" 1
VBoxManage guestproperty set ${VMNAME} "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold" 10000
}

for n in $( VBoxManage list vms | grep '^"' | cut -d\" -f2 ); do
	fix $n
done
