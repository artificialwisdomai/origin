###
#
# These are mandatory, hence they are:
#
# variables
# with default type
# without default value

variable "purpose" {
  type      = string
}

variable "distro_version" {
  type       = string
}

variable "iso_checksum" {
  type    = string
}

variable "iso_url" {
  type    = string
}

variable "guest_os_type" {
  type   = string
}

###
# NB: Any generated image must be smaller then this image size
# if this image is used to host the generated image.
#
variable "disk_size" {
  type    = string
  default = "200000"
}

###
#
# Please note target_path is relative to ${PWD}

variable "target_path" {
  type    = string
  default = "build/"
}

locals {
  version = formatdate("YYYYMMDDhhmmss", timestamp())
  vm_name = "${local.version}.${var.distro_version}.${var.purpose}"
  vdi_image = "${var.target_path}/${local.vm_name}.vdi"
  raw_image = "${var.target_path}/${local.vm_name}.raw"
  zst_image = "${var.target_path}/${local.vm_name}.raw.zst"
  oci_artifact = "${var.purpose}.raw.zst"
  preseed_file = "preseed-debian-${var.distro_version}.cfg"
  preseed_dir = "cfg"
  cpus = "4"
  memory = "16384"
  headless = "true"
}

source "virtualbox-iso" "base-debian-amd64" {
  # The Debian boot screen is well documented in 5.1.7 The Boot Screen
  # https://www.debian.org/releases/stable/i386/ch05s01.en.html#boot-screen
  boot_command = ["<down>e<down><down><down><end>priority=critical auto=true fb=false preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${local.preseed_file}<leftCtrlOn>x<leftCtrlOff>"]
  guest_os_type        = "${var.guest_os_type}"
  guest_additions_mode = "disable"
  cpus                 = "${local.cpus}"
  memory               = "${local.memory}"
  disk_size            = "${var.disk_size}"
  headless             = "${local.headless}"
  output_directory     = "${var.target_path}"
  output_filename      = "${local.vm_name}"
  http_directory       = "${path.root}/${local.preseed_dir}"
  communicator         = "ssh"
  skip_nat_mapping     = false
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  iso_interface        = "virtio"
  nic_type             = "virtio"
  hard_drive_interface = "virtio"
  rtc_time_base        = "UTC"
  shutdown_command     = "sudo -S shutdown -P now"
  ssh_password         = "insecure"
  ssh_username         = "packer"
  ssh_wait_timeout     = "30m"
  firmware             = "efi"
  keep_registered      = "true"
  skip_export          = "false"
  format               = "ova"
  vm_name              = "${local.vm_name}"
  vboxmanage = [
    [ "modifyvm", "{{.Name}}", "--recording", "on" ],
    [ "modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on" ],
  ]
}

build {
  sources = [
    "source.virtualbox-iso.base-debian-amd64"
  ]

  provisioner "ansible" {
    playbook_file = "provisioners/playbook.yml"
    ansible_env_vars = [
      "ANSIBLE_NOCOLOR=True"
    ]
    user = "packer"
  }

  post-processors {
    post-processor "shell-local" {
      inline = [ "vbox-img convert --srcformat vdi --srcfilename ${local.vdi_image} --dstformat RAW --dstfilename ${local.raw_image}" ]
    }
    post-processor "shell-local" {
      inline = [ "zstd --compress --format=zstd ${local.raw_image} -o ${local.zst_image}" ]
    }
    post-processor "shell-local" {
      inline= [ "oci artifacts generic artifact upload-by-path --repository-id ocid1.artifactrepository.oc1.phx.0.amaaaaaamsjifnaarolagsfeinzfliwqcoekkfqu3tfqevcnmchdaagxlola --artifact-path ${local.oci_artifact} --artifact-version ${local.version} --content-body ${local.zst_image}" ]
    }
  }
}
