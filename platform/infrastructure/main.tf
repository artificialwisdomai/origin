terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
    }
  }
}

provider "oci" {
  tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaaaa6vyjrctvv5ax3lzuah3ldtlnrvni6hxcqdzcfoxjw5stgu4vz32q"
  user_ocid            = "ocid1.user.oc1..aaaaaaaaihmxsgqpnkbsf5d7nmgm2xy3ctvkhf4oupu43gyti3pzfe6hpvua"
  fingerprint          = "3f:6c:1d:9b:ef:bc:03:c0:48:a6:63:d5:4c:81:74:54"
  private_key_path     = "~/.oci/robert-oci.pem"
  region               = "us-phoenix-1"
}

# Object storage bucket for Golden Image VMDK files
resource "oci_objectstorage_bucket" "debian_golden" {
  # Bucket configurations
  compartment_id = var.compartment_id
  name           = "debian-golden"
  namespace      = var.namespace
}

# Need to create a default VNC


# Need to create a default Subnet
