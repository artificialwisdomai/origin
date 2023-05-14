resource "oci_objectstorage_bucket" "debian_golden" {
  # Bucket configurations
  compartment_id = var.compartment_id
  name           = "debian-golden"
  namespace      = var.namespace
}

resource "oci_objectstorage_object" "debian_golden" {
  bucket    = oci_objectstorage_bucket.debian_golden.name
  source    = "golden.raw-disk001.vmdk"
  object    = "golden.raw-disk001.vmdk"
  namespace = var.namespace
}


## Seems this doesn't actually exist
# resource "oci_compute_image_import" "import_vmdk_image" {
#   display_name = "debian-golden"
#   compartment_id = var.compartment_id
#   bucket_name = "debian-golden"
#   object_name = "golden.raw-disk001.vmdk"
#   format = "VMDK"
#   source_details {
#     source_type = "objectStorageUri"
#     source_uri = oci_objectstorage_bucket.debian_golden.namespace_path
#   }
# }

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