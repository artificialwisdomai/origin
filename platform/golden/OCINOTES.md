# Notes for building and pushing to OCI directly from VirtualBox

## manual mode

Install the oci command line client

OSX

```sh
brew install oci-cli
```

Linux

```sh
python3 -m pip install oci-cli
```

Windows

```sh
choclatey install oci-cli
```

Configure with an OCI generated API key (gotta get that from the console: Profile->API keys). Don't forget the public key fingerprint as well.

Download the .pem file that is generated (don't forget to do this, or you'll just need to create a new key). Store it in the ~/.oci directory (create if it doesn't exist).

Also, you need your tenancy, user, and compartment OCIDs. You add them to:

```sh
cat >> ~/.oci/config <<EOF
[DEFAULT]
user=<USER_OCID>
tenancy=<TENANT_OCID>
region=us-phoenix-1
key_file=~/.oci/<API_AUTH_PRIVATE_KEY>.pem
fingerprint=<API_AUTH_PUB_FINGERPRINT>
EOF

cat >> ~/.oci/oci_cli_rc <<EOF
[DEFAULT]
compartment-id=<COMPARTMENT_ID>
EOF
```

Run upload-image.sh script

```sh
bash upload-image.sh
```
