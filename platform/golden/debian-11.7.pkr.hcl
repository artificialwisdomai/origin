# This file was autogenerated by the 'packer hcl2_upgrade' command. We
# recommend double checking that everything is correct before going forward. We
# also recommend treating this file as disposable. The HCL2 blocks in this
# file can be moved to other files. For example, the variable blocks could be
# moved to their own 'variables.pkr.hcl' file, etc. Those files need to be
# suffixed with '.pkr.hcl' to be visible to Packer. To use multiple files at
# once they also need to be in the same folder. 'packer inspect folder/'
# will describe to you what is in that folder.

# Avoid mixing go templating calls ( for example ```{{ upper(`string`) }}``` )
# and HCL2 calls (for example '${ var.string_value_example }' ). They won't be
# executed together and the outcome will be unknown.

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "virtualbox-iso" "autogenerated_1" {
  boot_command         = ["<esc><wait>", 
    "install", 
    " initrd=/install/initrd.gz", 
    " debian-installer=en_US auto locale=en_US kbd-chooser/method=us", 
    " fb=false debconf/frontend=noninteractive", 
    " keyboard-configuration/variant=USA console-setup/ask_detect=false ", 
    " keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA", 
    " auto-install/enable=true", 
    " debconf/priority=critical", 
    " debconf/frontend=noninteractive", 
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg", 
    " PACKER_USER=packer PACKER_AUTHORIZED_KEY={{ .SSHPublicKey | urlquery }}<wait>", 
    " -- ", "<enter>"]
  boot_wait            = "10s"
  cpus                 = "2"
  disk_size            = "32768"
  guest_additions_mode = "disable"
  guest_os_type        = "Debian11_64"
  headless             = "true"
  http_directory       = "cfg"
  iso_checksum         = "sha256:eb3f96fd607e4b67e80f4fc15670feb7d9db5be50f4ca8d0bf07008cb025766b"
  iso_url              = "https://cdimage.debian.org/debian-cd/11.7.0/amd64/iso-cd/debian-11.7.0-amd64-netinst.iso"
  memory               = "8192"
  shutdown_command     = "echo 'packer' | sudo -S shutdown -P now"
  ssh_username         = "packer"
  vm_name              = "debian-11.7"
  vboxmanage = [
    [ "modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on" ]
  ]
}
# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.virtualbox-iso.autogenerated_1"]

}