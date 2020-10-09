#!/bin/bash

printTask() {
	echo "-----------"
	echo "- Task $1 -"
	[[ $# -eq 2 ]] && echo "$2"
	echo "-----------"
}

ROOT_DEV="/dev/sda"

# -- 1 --
printTask 1 "Create partition"

# Not beautiful solution using 'parted'
#parted "$ROOT_DEV" unit MB print free
#parted "$ROOT_DEV" unit MB mkpart primary ext4  8590MB 8890MB
#parted "$ROOT_DEV" unit MB print free

# More beautiful using fdisk
SIZE="300M"
FDISK_DEFAULT=''

fdisk "$ROOT_DEV" <<EOF
p
n
$FDISK_DEFAULT
$FDISK_DEFAULT
+$SIZE
p
w
EOF

# -- 2 --
printTask 2 "Save UUID to file"

DEV="/dev/sda4"
UUID_FILE="/root/sda4_uuid"
blkid "$DEV" -o value -s UUID > "$UUID_FILE"

# -- 3 --
printTask 3 "mkfs.ext4"

BLOCK_SIZE="4096"
mkfs.ext4 -b "$BLOCK_SIZE" "$DEV"

# -- 4 --
printTask 4 "Print superblock info"

dumpe2fs -h "$DEV"

# -- 5 --
printTask 5 "tune2fs"

# Every two month, every 2nd mount
tune2fs -i 2m -C 2 "$DEV"

# -- 6 -- 
printTask 6 "mount"

MOUNTPOINT="/mnt/newdisk"

mkdir -p "$MOUNTPOINT"
mount -t ext4 "$DEV" "$MOUNTPOINT"
df -h

# -- 7 -- 
printTask 7 "symlink"

SYMLINK="/root/newdisk_symlink"
ln -s "$MOUNTPOINT" "$SYMLINK"
ls -l "/root/"
# -- 8 --
printTask 8 "mkdir on mounted partition"

CATALOG="$MOUNTPOINT/some_catalog"
mkdir "$CATALOG"
ls -l "$MOUNTPOINT"

# -- 9 --
printTask 9 "fstab"

FSTAB="/etc/fstab"
FSTAB_BACKUP="/root/fstab.backup"
UUID=$(blkid "$DEV" -o value -s UUID)

cp "$FSTAB" "$FSTAB_BACKUP"
echo "UUID=$UUID $MOUNTPOINT ext4 noexec,noatime 0 0" >> "$FSTAB"

cat "$FSTAB"

# -- 10 -- 
printTask 10 "Resize partition"

PART_NO=4
NEW_SIZE="350M"

df -h 

umount "$MOUNTPOINT"
fdisk "$ROOT_DEV" <<EOF
p
d
$FDISK_DEFAULT
n
$FDISK_DEFAULT
$FDISK_DEFAULT
+$NEW_SIZE
p
w
EOF

mount -t ext4 "$DEV" "$MOUNTPOINT"

resize2fs "$DEV"

df -h


# -- 11 -- 
printTask 11 "fsck"

fsck -n "$DEV"

# -- 12 -- 
printTask 12 "Create journal FS"

JRNL_SIZE="12M"
JRNL_DEV="/dev/sda5"

fdisk "$ROOT_DEV" <<EOF
p
n
$FDISK_DEFAULT
$FDISK_DEFAULT
+$JRNL_SIZE
p
w
EOF

mke2fs -b "$BLOCK_SIZE" -O journal_dev "$JRNL_DEV"

# On create
#mke2fs -t ext4 -J device="$JRNL_DEV" "$DEV"

# On tune
umount "$MOUNTPOINT"
tune2fs -O ^has_journal "$DEV"
tune2fs -J device="$JRNL_DEV" "$DEV"
mount -t ext4 "$DEV" "$MOUNTPOINT"

# Restore internal journal
#tune2fs -O has_journal "$DEV"

# -- 13 --
printTask 13 "Create 100M partitions x2"

DEV_2="/dev/sda6"
DEV_3="/dev/sda7"
DEV_2_3_SIZE="100M"

fdisk "$ROOT_DEV" <<EOF
p
n
$FDISK_DEFAULT
$FDISK_DEFAULT
+$DEV_2_3_SIZE
n
$FDISK_DEFAULT
$FDISK_DEFAULT
+$DEV_2_3_SIZE
p
w
EOF

# -- 14 --
printTask 14 "LVM"

VG_NAME="vg1"
LV_NAME="lv1"
LV_DEV="/dev/$VG_NAME/$LV_NAME"
LV_MOUNTPOINT="/mnt/supernewdisk"

pvcreate "$DEV_2" "$DEV_3"
vgcreate "$VG_NAME" "$DEV_2" "$DEV_3"
lvcreate -l 100%FREE -n "$LV_NAME" "$VG_NAME"

mkfs.ext4 "$LV_DEV"
mkdir -p "$LV_MOUNTPOINT"
mount "$LV_DEV" "$LV_MOUNTPOINT"

df -h

