apt-get install cifs-utils

mkdir /k8s-pv

# mount credentials
cat >>/etc/samba-credentials<<EOF
username=app
password=app
EOF

# mount each restart
cat >>/etc/fstab<<EOF
//192.168.0.163/k8s-pv /k8s-pv cifs credentials=/etc/samba-credentials,uid=1000,gid=1000,file_mode=0777,dir_mode=0777 0 0
EOF

# after editing /etc/fstab
mount -a