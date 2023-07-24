variable "preseed_file" {
  type    = string
  default = "preseed-debian-11.cfg"
}

variable "preseed_dir" {
  type    = string
  default = "cfg"
}

variable "cpus" {
  type    = string
  default = "4"
}

variable "disk_size" {
  type    = string
  default = "200000"
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
  default = "https://cdimage.debian.org/cdimage/archive/11.7.0/amd64/iso-cd/debian-11.7.0-amd64-netinst.iso"
}

variable "image_name" {
  type    = string
  default = "golden"
}

source "virtualbox-iso" "base-debian-amd64" {
  # The Debian boot screen is well documented in 5.1.7 The Boot Screen
  # https://www.debian.org/releases/stable/i386/ch05s01.en.html#boot-screen
  boot_command = ["<down>e<down><down><down><end>priority=critical auto=true fb=false preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_file}<leftCtrlOn>x<leftCtrlOff>"]
  guest_os_type        = "Debian11_64"
  guest_additions_mode = "disable"
  cpus                 = "${var.cpus}"
  memory               = "${var.memory}"
  disk_size            = "${var.disk_size}"
  headless             = "${var.headless}"
  output_directory     = "build"
  output_filename      = "${var.image_name}"
  http_directory       = "${path.root}/${var.preseed_dir}"
  communicator         = "ssh"
  skip_nat_mapping     = false
  iso_checksum         = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  iso_interface        = "virtio"
  nic_type             = "virtio"
  hard_drive_interface = "virtio"
  rtc_time_base        = "UTC"
  shutdown_command     = "sudo -S shutdown -P now"
  ssh_password         = "insecure"
  ssh_username         = "packer"
  ssh_wait_timeout     = "10m"
  firmware             = "efi"
  keep_registered      = "true"
  skip_export          = "false"
  vboxmanage = [
    [ "modifyvm", "{{.Name}}", "--recording", "on" ],
    [ "modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on" ],
  ]
}

# Build a golden image by connecting a compute source with a provisioner

build {
  sources = ["source.virtualbox-iso.base-debian-amd64"]
}
