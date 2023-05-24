variable "config_file" {
  type    = string
  default = "preseed-debian-11.cfg"
}

variable "config_dir" {
  type    = string
  default = "cfg"
}

variable "cpus" {
  type    = string
  default = "4"
}

variable "disk_size" {
  type    = string
  default = "65536"
}

variable "memory" {
  type    = string
  default = "16384"
}

variable "headless" {
  type    = string
  default = "true"
}

variable "iso_checksum" {
  type    = string
  default = "4460ef6470f6d8ae193c268e213d33a6a5a0da90c2d30c1024784faa4e4473f0c9b546a41e2d34c43fbbd43542ae4fb93cfd5cb6ac9b88a476f1a6877c478674"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha512"
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/debian-cd/11.7.0/amd64/iso-cd/debian-11.7.0-amd64-netinst.iso"
}

variable "image_name" {
  type    = string
  default = "golden"
}

variable "ssh_password" {
  type    = string
}

source "virtualbox-iso" "base-debian-amd64" {
  boot_command         = [
    "<esc><wait>",
    "auto <wait>",
    "fb=false <wait>",
    "install <wait>", 
    "passwd/username=packer <wait>",
    "passwd/user-password=${var.ssh_password} <wait>",
    "passwd/user-password-again=${var.ssh_password} <wait>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.config_file}<wait>",
    "<enter><wait>"
  ]
  guest_os_type        = "Debian11_64"
  cpus                 = "${var.cpus}"
  memory               = "${var.memory}"
  disk_size            = "${var.disk_size}"
  headless             = "${var.headless}"
  output_directory     = "build"
  output_filename      = "${var.image_name}.raw"
  http_directory       = "${path.root}/${var.config_dir}"
  communicator         = "ssh"
  skip_nat_mapping     = false
  iso_checksum         = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  iso_interface        = "virtio"
  nic_type             = "virtio"
  hard_drive_interface = "virtio"
  rtc_time_base        = "UTC"
  shutdown_command     = "sudo -S shutdown -P now"
  ssh_username         = "packer"
  ssh_password         = "${var.ssh_password}"
  ssh_wait_timeout     = "30m"
  vboxmanage = [
    # enable recording video of install process, for debug and build record
    [ "modifyvm", "{{.Name}}", "--recording", "on" ],
    [ "modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on" ],
    [ "modifyvm", "{{.Name}}", "--firmware", "efi"],
    ["modifyvm", "{{.Name}}", "--vram", "16"]
  ]
}

# Build a golden image by connecting a compute source with a provisioner

build {
  sources = ["source.virtualbox-iso.base-debian-amd64"]

# Use Ansible (needs to be on the "packer" host) to provision the instance
  provisioner "ansible" {
    playbook_file = "./provisioners/01_update_packer_user/packer.yml"
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_SSH_ARGS='-oForwardAgent=yes -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=ssh-rsa'"
    ]
    # Add scp-extra-args -O to address inconsistencies with SFTP protocol
    extra_arguments = [ "--scp-extra-args", "'-O'" ]
    # Set username to install user 'packer'
    user="packer"
  }
}
