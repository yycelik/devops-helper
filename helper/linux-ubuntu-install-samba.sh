mkdir /samba-share

chmod 777 /samba-share

sudo apt update

sudo apt install samba

nano /etc/samba/smb.conf

[k8s-pv]
   comment = Samba share directory
   path = /samba-share
   read only = no
   writable = yes
   browseable = yes
   guest ok = no
   valid users = @app
   create mask = 0777
   force create mode = 0777
   directory mask = 0777
   force directory mode = 0777
	
# restart service
service smbd restart


# give permisson with group
sudo smbpasswd -a {username}
#sudo addgroup smbgrp
#sudo useradd shares -G smbgrp
#sudo smbpasswd -a shares
#sudo useradd app -G smbgrp
#chmod -R 0770 /samba-share
#chown root:smbgrp /samba-share

# restart service
service smbd restart

# if you want to clean user cridential on windows
net stop workstation /y
net start workstation


# linux     //192.168.0.163/samba-share
# windows   \\192.168.0.163\samba-share