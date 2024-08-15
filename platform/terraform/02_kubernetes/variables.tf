###
#
# Authentication

variable "api_fingerprint" {
  description = "Fingerprint of the API private key to use with OCI API."
  type        = string
}

variable "api_private_key_path" {
  description = "The path to the OCI API private key pem file."
  type        = string
}

#variable "ssh_private_key_path" {
#  description = "The path to ssh private key."
#  type        = string
#}

#variable "ssh_public_key_path" {
#  description = "The path to ssh public key."
#  type        = string
#}

###
#
# Identity Management

variable "user_id" {
  description = "The id of the user that Terraform will use to create the resources."
  type        = string
}
variable "tenancy_id" {
  description = "The tenancy id of the OCI Cloud Account in which to create the resources."
  type        = string
}

variable "compartment_id" {
  description = "The compartment id where to create all resources."
  type        = string
}

# this may not be needed
#variable "home_region" {
#  description = "The home region for this compartment."
#  type        = string
#}


###
#
# Cluster Networking Configuration

# It would be cool to enhance this such that an array of clusters could be created.
variable "vcn_cidrs" {
    description = "VCN CIDRs. I don't know how this is used"
    type        = list
}
variable "pods_cidr" {
    description = "Network CIDR associated with PODs. Must be a /16 that does not overlap with other networks."
    type        = string
}

variable "services_cidr" {
    description = "Services CIDR associated with Services. Must be a /16 tha does not overlap with other networks."
    type        = string
}

# It would be cool to enhance this such that an array of clusters could be created.
###
#
# Kubernetes Control Plane Configuration

variable "region" {
  description = "Create Kubernetes in this region."
  type        = string
}

variable "kubernetes_version" {
  default     = "v1.30.1"
  description = "Create Kubernetes using this version."
  type        = string
}

variable "worker_nodes" {
  default     = "3"
  description = "Create Kubernetes with this worker node count."
  type        = number
}

variable "worker_memory" {
  default     = "16"
  description = "Create each worker with this much memory in gigabytes."
  type        = number
}

variable "worker_cpu" {
  default     = "4"
  description = "Create each worker with this many virtual CPUs."
  type        = number
}
