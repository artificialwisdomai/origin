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
        " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed2.cfg PACKER_USER=packer PACKER_AUTHORIZED_KEY={{ .SSHPublicKey | urlquery }}<enter>",
	"debian-installer=en_US.UTF-8 <wait>",
        "auto <wait>",
        "locale=en_US.UTF-8 <wait>",
        "kbd-chooser/method=us <wait>",
        "keyboard-configuration/xkb-keymap=us <wait>",
        "netcfg/get_hostname={{ .Name }} <wait>",
        "netcfg/get_domain=vagrantup.com <wait>",
        "fb=false <wait>",
        "debconf/frontend=noninteractive <wait>",
        "console-setup/ask_detect=false <wait>",
        "console-keymaps-at/keymap=us <wait>",
        "grub-installer/bootdev=/dev/sda <wait>",
	"<enter><wait>"
  ]

  http_directory       = "cfg"
  cpus                 = 8
  disk_size            = 65535
  guest_os_type        = "Debian11_64"
  guest_additions_mode = "disable"
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
  ssh_username         = "packer"
  ssh_password         = "packer"
  ssh_wait_timeout     = "5m"
}

# Build a golden image by connecting a compute source with a provisioner
build {
  sources = [
    "source.virtualbox-iso.base-debian-amd64"
  ]
}
