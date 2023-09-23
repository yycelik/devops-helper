
sudo cat >>/etc/docker/daemon.json<<EOF
{
    "insecure-registries" : [ "docker-r.nexus.smart.com" ]
}

sudo systemctl restart docker