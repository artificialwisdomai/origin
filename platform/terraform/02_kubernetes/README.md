
# Deploy and use Kubernetes

Initialize terraform:

```
terraform init
```

Create a Kubernetes deployment:

```
terraform apply
```

Destroy the Kubernetes deployment:

```
terraform destroy
```

When you create the Kubernetes deployment, an `ocid.cluster....` is printed.

Set the OCID cluster enviornment variable:
```
CLUSTER_OCID="value from terraform apply"
```

Setup `kubectl` via `$HOME/.kube/config`

```
oci ce cluster create-kubeconfig --cluster-id "${CLUSTER_OCID}" --file $HOME/.kube/config --region us-phoenix-1 --token-version 2.0.0  --kube-endpoint PUBLIC_ENDPOINT
```
