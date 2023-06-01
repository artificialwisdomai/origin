# Platform build IAC

## Directory Structure

/infrastructure
- Default resoruces that are normally created at the start of a project, and not deleted until the end
- Virtual Cloud (VPC, VNC, Zone, etc.)
- Virtual Cloud subnet(s)
- Virtual Cloud Routers, Gateways, VPNs?
- Shared object storage buckets

Currently builds a bucket for the golden image upload

```sh
terraform init
terraform plan -out infra.tfplan
terraform apply infra.tfplan
```

/golden
- Golden Image building blocks and tools

```sh
bash run.sh
upload-image.sh
#or
terraform init
terraform plan -out image.tfplan
terraform apply image.tfplan
```

/golden-vm
- Test VM for Golden Images
- Test BM for Golden Images

```sh
terraform init
terraform plan -out instance.tfplan
terraform apply instance.tfplan

# validate login to IP address
terraform apply -destroy -auto-approve
```

