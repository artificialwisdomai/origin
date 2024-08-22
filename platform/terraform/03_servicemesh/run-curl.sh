ingress_ip=$(kubectl get svc -n istio-ingress istio-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl -v http://${ingress_ip}:80/
#curl -v -H "Host: httpbin.example.com" http://${ingress_ip}:80/health
#curl -v -H "Host: vllm" http://${ingress_ip}:80
#curl -v http://${ingress_ip}:80
echo "This is the ingress gateway --------------------->"

kubectl logs -n istio-ingress -l istio=ingressgateway
echo "This is the eastwest gateway --------------------->"
kubectl logs -n istio-ingress -l istio=eastwestgateway
