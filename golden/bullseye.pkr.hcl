variables {
  headless          = true
  iso_checksum      = "224cd98011b9184e49f858a46096c6ff4894adff8945ce89b194541afdfd93b73b4666b0705234bd4dff42c0a914fdb6037dd0982efb5813e8a553d8e92e6f51"
  iso_checksum_type = "sha512"
  iso_url           = "https://cdimage.debian.org/debian-cd/11.6.0/amd64/iso-cd/debian-11.6.0-amd64-netinst.iso"
}

source "virtualbox-iso" "base-debian-amd64" {
  boot_command         = [
        "<esc><wait>",
        "install <wait>",
        " auto=true",
        " priority=critical",
        " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg PACKER_USER=packer PACKER_AUTHORIZED_KEY={{ .SSHPublicKey | urlquery }}<enter>",
	"<enter><wait>"
  ]

  http_directory       = "/home/sdake/images/cfg"
  cpus                 = 8
  disk_size            = 65535
  guest_os_type        = "Debian11_64"
  guest_additions_mode = "attach"
  guest_additions_interface = "virtio"
  headless             = true
  output_directory     = "build"
  output_filename      = "golden.raw"
  communicator         = "ssh"
  skip_nat_mapping     = false
  iso_checksum         = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_interface        = "virtio"
  iso_url              = "${var.iso_url}"
  memory               = 16384
  nic_type             = "virtio"
  hard_drive_interface = "virtio"
  rtc_time_base        = "UTC"
  shutdown_command     = "echo 'packer' | sudo -S shutdown -P now"
  ssh_wait_timeout     = "30m"
  ssh_username         = "packer"
  vboxmanage = [
    [ "modifyvm", "{{.Name}}", "--recording", "on" ],
    [ "modifyvm", "{{.Name}}", "--nic1", "natnetwork" ]
  ]
}

# Build a golden image by connecting a compute source with a provisioner
build {
  sources = [
    "source.virtualbox-iso.base-debian-amd64"
  ]
}