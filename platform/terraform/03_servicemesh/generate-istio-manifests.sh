###
#
# This was tested with Istio 1.22.3
# 
# curl -LO https://github.com/istio/istio/releases/download/1.17.1/istio-1.22.3-linux-amd64.tar.gz


###
#
# ambient mode does not work with virtual machines
# ambient mode appears to require ztunnel
# to enable ambient mode, use `--set profile=ambient` with `istio-cni` and `istiod`. Add ztunnel.
# helm template ztunnel istio/ztunnel --namespace istio-system > istio-ztunnel.yaml


###
#
# Helm is currently recommended upstream.
# use `helm template` to create a record of manifests.

#helm repo add istio https://istio-release.storage.googleapis.com/charts
#helm repo update
#helm template istio-cni istio/cni --namespace istio-system > istio-cni.yaml

helm template istio-base istio/base --namespace istio-system --include-crds --values values-base.yaml > istio-base.yaml
helm template istiod istio/istiod --namespace istio-system --values values-istiod-multi.yaml > istio-istiod-multi.yaml
helm template istio-ingress istio/gateway --namespace istio-ingress --values values-gateway-multi.yaml > istio-gateway-multi.yaml
helm template istio-ingress istio/gateway --namespace istio-ingress --values values-gateway-eastwest-multi.yaml > istio-gateway-eastwest-multi.yaml
