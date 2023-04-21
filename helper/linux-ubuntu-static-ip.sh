ip a
sudo tee /etc/netplan/00-installer-config.yaml<<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      addresses:
        - 192.168.0.220/24
      gateway4: 192.168.0.1
      nameservers:
          addresses: [1.1.1.1, 1.0.0.1]
EOF