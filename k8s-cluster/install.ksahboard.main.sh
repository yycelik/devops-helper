echo "#####################################################################################"
echo "#################################### Step 1: Install Kubernetes Dashboard"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

echo "#####################################################################################"
echo "#################################### Step 2: Create Token"
>sa_cluster_admin.yaml
cat >>/etc/hosts<<EOF
# Create Dashboard tokennano
apiVersion: v1
kind: ServiceAccount
metadata:
  name: dashboard-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cluster-admin-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: dashboard-admin
  namespace: kube-system
EOF
kubectl create -f sa_cluster_admin.yaml
kubectl -n kube-system get sa
kubectl -n kube-system describe sa dashboard-admin
kubectl -n kube-system describe secret {Tokens}
echo "#####################################################################################"
echo "#################################### Step 3: Proxy Configuration"
#kubectl proxy --port=9999 --address='{masterip}' --accept-hosts="^*$"
kubectl proxy --port=9999 --address='172.16.0.5' --accept-hosts="^*$"
#http://127.0.0.1:29999/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.