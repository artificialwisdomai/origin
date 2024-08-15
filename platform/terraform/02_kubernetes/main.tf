module "kubernetes" {
    source = "git::https://github.com/oracle-terraform-modules/terraform-oci-oke"
    providers = {
        oci.home = oci
    }

    api_fingerprint      = var.api_fingerprint
    api_private_key_path = var.api_private_key_path
    tenancy_id           = var.tenancy_id
    compartment_id       = var.compartment_id
    user_id              = var.user_id
    vcn_cidrs            = var.vcn_cidrs
    region               = var.region
    kubernetes_version   = var.kubernetes_version
    pods_cidr            = var.pods_cidr
    services_cidr        = var.services_cidr

    ###
    #
    # Networking Configuration

    cni_type = local.cni_type
    kubeproxy_mode               = local.kubeproxy_mode
    create_drg                   = local.create_drg


    ###
    #
    # Kubernetes Control Plane Configuration

    create_cluster = local.create_cluster
    cluster_type = local.cluster_type
    control_plane_allowed_cidrs = local.control_plane_allowed_cidrs
    control_plane_is_public = local.control_plane_is_public
    assign_public_ip_to_control_plane = local.assign_public_ip_to_control_plane
    #create_iam_resources = local.create_iam_resources

    ###
    #
    # Kubernetes Worker Nodes Configuration

    create_iam_resources = local.create_iam_resources
    worker_pool_mode = local.worker_pool_mode
    allow_worker_ssh_access = local.allow_worker_ssh_access
    worker_pools = local.worker_pools
    worker_cloud_init = local.worker_cloud_init

    ###
    #
    # Extra nodes

    create_bastion = local.create_bastion
    create_operator = local.create_operator
}
