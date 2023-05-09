# Notes for building and pushing to OCI directly from VirtualBox

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