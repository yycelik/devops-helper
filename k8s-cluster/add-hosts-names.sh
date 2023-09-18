# https://stackoverflow.com/questions/71234801/kubernetes-pods-unable-to-resolve-external-host

kubectl edit configmap coredns -n kube-system

#apiVersion: v1
#data:
#  Corefile: |
#    .:53 {
#        ...
#        kubernetes cluster.local in-addr.arpa ip6.arpa {
#           pods insecure
#           fallthrough in-addr.arpa ip6.arpa
#           ttl 30
#        }
#
#        ### Add the following section ###
#        hosts {
#          {ip1} {hostname1}
#          {ip2} {hostname2}
#          ...
#          fallthrough
#        }
#
#        prometheus :9153
#        ...
#    }