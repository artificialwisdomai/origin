# Copyright (c) 2024 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

provider "oci" {
  fingerprint         = var.api_fingerprint
  private_key_path    = var.api_private_key_path
  region              = var.region
  compartment_ocid    = var.compartment_id
  tenancy_ocid        = var.tenancy_id
  user_ocid           = var.user_id
  alias               = "home"
  ignore_defined_tags = ["Oracle-Tags.CreatedBy", "Oracle-Tags.CreatedOn"]
}
