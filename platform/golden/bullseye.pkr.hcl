variable "config_file" {
  type    = string
  default = "debian-11-preseed.cfg"
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
  default = "4096"
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
  default = "eb3f96fd607e4b67e80f4fc15670feb7d9db5be50f4ca8d0bf07008cb025766b"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
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
  default = "packer"
}

variable "ssh_username" {
  type    = string
  default = "packer"
}

source "virtualbox-iso" "base-debian-amd64" {
  boot_command         = [
    "<esc><wait>",
    "auto <wait>",
    "console-keymaps-at/keymap=us <wait>",
    "console-setup/ask_detect=false <wait>",
    "debconf/frontend=noninteractive <wait>",
    "debian-installer=en_US <wait>",
    "fb=false <wait>",
    "install <wait>", 
    "kbd-chooser/method=us <wait>",
    "keyboard-configuration/xkb-keymap=us <wait>",
    "locale=en_US <wait>",
    "netcfg/get_hostname=debian-11-7 <wait>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.config_dir}/${var.config_file} <wait>",
     "<enter><wait>"
  ]
  cpus                 = "${var.cpus}"
  disk_size            = "${var.disk_size}"
  headless             = "${var.headless}"
  output_directory     = "build"
  output_filename      = "${var.image_name}.raw"
  http_directory       = "${var.config_dir}"
  communicator         = "ssh"
  skip_nat_mapping     = false
  iso_checksum         = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  iso_interface        = "virtio"
  memory               = "${var.memory}"
  nic_type             = "virtio"
  hard_drive_interface = "virtio"
  rtc_time_base        = "UTC"
  shutdown_command     = "echo '${var.ssh_username}' | sudo -S shutdown -P now"
  ssh_username         = "${var.ssh_username}"
  ssh_password         = "${var.ssh_password}"
  ssh_wait_timeout     = "30m"
  vboxmanage = [
    [ "modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on" ]
  ]
}

# Build a golden image by connecting a compute source with a provisioner
build {
  sources = ["source.virtualbox-iso.base-debian-amd64"]

}
