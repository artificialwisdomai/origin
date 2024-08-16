# https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-provider/01-summary.htm
mkdir $HOME/.oci
chmod 700 $HOME/.oci
openssl genrsa -out $HOME/.oci/steve_private.pem 2048
chmod 600 $HOME/.oci/steve_private.pem
openssl rsa -pubout -in $HOME/.oci/steve_private.pem -out $HOME/.oci/steve_public.pem
cat $HOME/.oci/steve_public.pem

# Configure OCI cloud
oci setup config

# manually copy config variables to 01_kubernetes/terraform.tfvars
echo configure 01_kubernetes/terraform.tfvars
