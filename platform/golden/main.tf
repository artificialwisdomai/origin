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

data "oci_objectstorage_bucket" "debian_golden" {
  name           = "debian-golden"
  namespace      = var.namespace
}

resource "oci_objectstorage_object" "debian_golden" {
  bucket    = data.oci_objectstorage_bucket.debian_golden.name
  source    = "${path.module}/build/golden.raw-disk001.vmdk"
  object    = "golden.raw-disk001.vmdk"
  namespace = var.namespace
}

resource "oci_core_image" "debian_golden" {
    #Required
    compartment_id = var.compartment_id

    #Optional
    display_name = var.image_display_name
    launch_mode = var.image_launch_mode

    image_source_details {
        source_type = "objectStorageTuple"
        bucket_name = var.bucket_name
        namespace_name = var.namespace
        object_name = oci_objectstorage_object.debian_golden.object # exported image name
    }
}
