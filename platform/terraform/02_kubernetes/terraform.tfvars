###
#
# Authentication

api_fingerprint      = "c6:1d:a5:54:c2:d2:67:26:6a:81:b8:e0:d2:f5:f7:a7"
api_private_key_path = "/hoem/sdake/.oci/oci_api_key.pem"


###
#
# Identity Management

tenancy_id     = "ocid1.tenancy.oc1..aaaaaaaa6vyjrctvv5ax3lzuah3ldtlnrvni6hxcqdzcfoxjw5stgu4vz32q"
compartment_id = "ocid1.compartment.oc1..aaaaaaaaq6xqdldlmtkmkpypkhsjymplonmuvbfpdqfii7ezu6b23utwqtba"
user_id        = "ocid1.user.oc1..aaaaaaaa64i4tqgymgevje33u6tx7ejxgh2dipggg42lwikdr4f2ouwids5a"


###
#
# Kubernetes Configuration

region             = "us-phoenix-1"
kubernetes_version = "v1.30.1"
worker_nodes       = 3
worker_cpu         = 2
worker_memory      = 16
pods_cidr          = "10.201.0.0/16"
services_cidr      = "10.101.0.0/16"
