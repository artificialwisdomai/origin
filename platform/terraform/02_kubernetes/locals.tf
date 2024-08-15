locals {

    ###
    #
    # Networking Configuration

    cni_type                     = "flannel"
    kubeproxy_mode               = "iptables"
    create_drg                   = true


    ###
    #
    # Kubernetes Control Plane Configuration

    create_cluster                    = true
    cluster_type                      = "basic"
    oke_control_plane                 = "public"
    control_plane_allowed_cidrs       = ["0.0.0.0/0"]
    control_plane_is_public           = true
    assign_public_ip_to_control_plane = true
    create_iam_resources              = true


    ###
    #
    # Kubernetes Worker Nodes Configuration

    worker_image_type       = "oke"
    worker_pool_mode        = "node-pool"
    allow_worker_ssh_access = false
    worker_pools            = {
        np1 = {
            create           = true,
            size             = var.worker_nodes,
            shape            = "VM.Standard.E4.Flex",
            ocpus            = var.worker_cpu,
            memory           = var.worker_memory,
         }
    }

    worker_cloud_init = [
        {
            content      = <<-EOT
            runcmd:
            - 'echo "Kernel module configuration for Istio and worker node initialization"'
            - 'modprobe br_netfilter'
            - 'modprobe nf_nat'
            - 'modprobe xt_REDIRECT'
            - 'modprobe xt_owner'
            - 'modprobe iptable_nat'
            - 'modprobe iptable_mangle'
            - 'modprobe iptable_filter'
            - '/usr/libexec/oci-growfs -y'
            - 'timedatectl set-timezone Australia/Sydney'
            - 'curl --fail -H "Authorization: Bearer Oracle" -L0 http://169.254.169.254/opc/v2/instance/metadata/oke_init_script | base64 --decode >/var/run/oke-init.sh'
            - 'bash -x /var/run/oke-init.sh'
            EOT
              content_type = "text/cloud-config",
        }
    ]

    ###
    #
    # Extras

    create_bastion = false
    create_service_account = true
    create_operator = false
}
