#!/bin/bash

printTask() {
	echo "-----------"
	echo "- Task $1 -"
	[[ $# -eq 2 ]] && echo "$2"
	echo "-----------"
}

# -- 15 --
printTask 15 "CIFS"
# requires cifs-utils

NETADDR="//10.0.2.4/qemu"
SHARE_MOUNTPOINT="/mnt/share"
CONF="/root/.smbclient"
FSTAB="/etc/fstab"
FSTAB_BACKUP="/root/fstab.backup2"

mkdir -p "$SHARE_MOUNTPOINT"
mount.cifs "$NETADDR" "$SHARE_MOUNTPOINT" -o user="$SMB_USER",password="$SMB_PASSWORD"

# /root/.smbclient
echo "username=$SMB_USER
password=$SMB_PASSWORD" > "$CONF"

# -- 16 --
printTask 16 "FSTAB-CIFS"

cp "$FSTAB" "$FSTAB_BACKUP"
echo "$NETADDR $SHARE_MOUNTPOINT cifs user,rw,credentials=$CONF 0 0" >> "$FSTAB"


