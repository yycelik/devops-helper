#install
sudo apt install postgresql

# set password
sudo -i -u postgres psql
\password postgres


# modify adress
nano /etc/postgresql/14/main/postgresql.conf
	#listen_addresses = 'localhost' >> listen_addresses = '*'


# add at the end of the line
nano /etc/postgresql/14/main/pg_hba.conf
host all all 0.0.0.0/0 md5
host all all ::0/0 md5

# restart and check service
systemctl restart postgresql.service
systemctl status postgresql.service

#control ports
ss -nlt | grep 5432
