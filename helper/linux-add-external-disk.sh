dmesg | grep sd

fdisk -l
#Disk /dev/sda or /dev/sdb: 249 GiB

dmesg | grep sda

fdisk /dev/sda

n

e

1

Enter

Enter

p

t

L

83

w

mkfs.ext4 /dev/sda

fsck /dev/sda -f -y

#reboot

mkdir /samba-share

mount /dev/sdb /samba-share

df


# get /dev/sda or /dev/sdb
fdisk -l

# get UUID for /dev/sda or /dev/sdb
sudo blkid

# mount each restart
cat >>/etc/fstab<<EOF
UUID={UUID} /samba-share ext4 defaults 0 0
EOF
