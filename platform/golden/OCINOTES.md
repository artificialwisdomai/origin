# Notes for building and pushing to OCI directly from VirtualBox

## Blogs describe how to move an image from VBox > OCI

https://www.oracle.com/us/technologies/virtualization/oracle-vm-vb-oci-export-20190502-5480003.pdf

Actually, if you go far enough in this blog article (part 8):

https://blogs.oracle.com/virtualization/post/export-vm-from-virtualbox-to-oci-part-8

He gives the command:
VBoxManage export <machine>
--output OCI://
[--vsys <number of virtual system>]
[--vmname <name>]
[--cloud <number of virtual system>]
[--vmname <name>]
[--cloudprofile <cloud profile name>]
[--cloudbucket <bucket name>]
[--cloudkeepobject <true/false>]
[--cloudlaunchmode EMULATED|PARAVIRTUALIZED]
[--cloudlaunchinstance <true/false>]
[--clouddomain <domain>]
[--cloudshape <shape>]
[--clouddisksize <disk size in GB>]
[--cloudocivcn <OCI vcn id>]
[--cloudocisubnet <OCI subnet id>]
[--cloudpublicip <true/false>]
[--cloudprivateip <ip>]
[--cloudinitscriptpath <script path>]

## Move the packer golden image

https://blogs.oracle.com/cloud-infrastructure/post/using-packer-and-virtualbox-to-bring-your-own-image-into-oracle-cloud-infrastructure

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

configure with an OCI generated API key (gotta get that from the console: `https://cloud.oracle.com/identity/domains/my-profile/api-keys?region=us-phoenix-1`). Don't foget the public key fingerprint as well.

Download the .pem file that is generated (don't forget to do this, or you'll just need to create a new key). Store it in the ~/.oci directory (create if it doesn'[t exist).
])
Also, you need your tenancy, user, and compartment OCIDs. You

add them to:

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


