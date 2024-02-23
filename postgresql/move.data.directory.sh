# control data and conf dir
sudo -i -u postgres psql

# get conf directory
SHOW config_file;
	/etc/postgresql/14/main/postgresql.conf

# get data directory
SHOW data_directory;
	/var/lib/postgresql/14/main

# quite
\q

# stop service
systemctl stop postgresql.service


# give permision to the new directory
chown postgres:postgres /postgresql-data
chmod 700 /postgresql-data

# move data files
rsync -av /var/lib/postgresql/14/main/ /postgresql-data

# modify data directory on config
nano /etc/postgresql/14/main/postgresql.conf
	data_directory = '/postgresql-data'


#start service
systemctl start postgresql.service
systemctl status postgresql.service