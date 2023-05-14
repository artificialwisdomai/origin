resource "oci_objectstorage_bucket" "debian_golden" {
  # Bucket configurations
  compartment_id = var.compartment_id
  name           = "debian-golden"
  namespace      = var.oci_namespace
}

resource "oci_objectstorage_object" "debian_golden" {
  bucket    = oci_objectstorage_bucket.debian_golden.name
  source    = "build/golden.raw-disk001.vmdk"
  object    = "golden.raw-disk001.vmdk"
  namespace = var.oci_namespace
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