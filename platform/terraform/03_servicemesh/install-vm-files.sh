###
#
# Make sure the service istio-eastwestgateway has an assigned external ip.
# Multi-network, automatic workloadentry creation:
# https://istio.io/latest/docs/setup/install/virtual-machine/

###
#
# This creates files to install on the virtual machine.

mkdir -p "$(pwd)/vm-files"
ingress_ip=$(kubectl get svc istio-eastwestgateway -n istio-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
istioctl x workload entry configure -f workloadgroup.yaml -o "$(pwd)/vm-files" --clusterID "cluster1" --ingressIP "${ingress_ip}"

###
#
# This needs to be run on the virtual machine.

sudo systemctl stop istio
sudo rm -rf /etc/certs/*
sudo mkdir -p /etc/certs
sudo cp vm-files/mesh.yaml /etc/istio/config/mesh
sudo cp vm-files/root-cert.pem /etc/certs/root-cert.pem
sudo cp vm-files/cluster.env /var/lib/istio/envoy/cluster.env
sudo cp vm-files/istio-token /var/run/secrets/tokens/istio-token
sudo mkdir -p /etc/istio/proxy
sudo chown -R istio-proxy /var/lib/istio /etc/certs /etc/istio/proxy /etc/istio/config /var/run/secrets /etc/certs
sudo systemctl start istio
