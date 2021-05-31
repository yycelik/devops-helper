echo "#####################################################################################"
echo "#################################### Step 1: Install Kubernetes Servers"
sudo apt update
sudo apt -y upgrade
echo "#####################################################################################"
echo "#################################### Step 2: Install kubelet, kubeadm and kubectl"
sudo apt update
sudo apt -y install curl apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
echo "#####################################################################################"
echo "#################################### Step 3: Check kubelet, kubeadm and kubectl"
kubectl version --client && kubeadm version
echo "#####################################################################################"
echo "#################################### Step 4: Disable Swap"
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
echo "#####################################################################################"
echo "#################################### Step 5: Configure sysctl"
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
echo "#####################################################################################"
echo "#################################### Step 6: Install Container runtime"
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y containerd.io docker-ce docker-ce-cli
echo "#####################################################################################"
echo "#################################### Step 7: Create required directories"
sudo mkdir -p /etc/systemd/system/docker.service.d
echo "#####################################################################################"
echo "#################################### Step 8: Create daemon json config file"
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
echo "#####################################################################################"
echo "#################################### Step 9: Start and enable Services"
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker
echo "#####################################################################################"
echo "#################################### Step 10: Initialize master node"
lsmod | grep br_netfilter
sudo systemctl enable kubelet
sudo kubeadm config images pull
echo "#####################################################################################"
echo "#################################### Step 11: Dns"
cat >>/etc/hosts<<EOF
192.168.56.110 kmaster.com kmaster
192.168.56.111 kworker1.com kworker1
EOF
echo "#####################################################################################"
echo "#################################### Step 12: Create cluster"
sudo kubeadm init \
  --pod-network-cidr=192.169.0.0/16 \
  --control-plane-endpoint=kmaster.com
echo "#####################################################################################"
echo "#################################### Step 13: Create cluster"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo "#####################################################################################"
echo "#################################### Step 14: Get cluster status"
kubectl cluster-info
echo "#####################################################################################"
echo "#################################### Step 15: Create token for cluster node(s)"
kubeadm token list
sudo kubeadm token delete {id from list}
kubeadm token create --print-join-command
echo "#####################################################################################"
echo "#################################### Step 16: Install network plugin on Master"
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
echo "#################################### Step 17: Confirm that all of the pods are running:"
watch kubectl get pods --all-namespaces
echo "#################################### Step 18: Confirm master node is ready:"
kubectl get nodes -o wide