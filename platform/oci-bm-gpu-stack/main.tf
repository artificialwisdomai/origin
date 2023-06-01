provider "oci" {}

resource "oci_core_instance" "generated_oci_core_instance" {
	agent_config {
		is_management_disabled = "false"
		is_monitoring_disabled = "false"
		plugins_config {
			desired_state = "DISABLED"
			name = "Vulnerability Scanning"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Oracle Java Management Service"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Oracle Autonomous Linux"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "OS Management Service Agent"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Compute Instance Run Command"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Compute Instance Monitoring"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Block Volume Management"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Bastion"
		}
	}
	availability_domain = "zyFb:PHX-AD-1"
	compartment_id = "ocid1.compartment.oc1..aaaaaaaaq6xqdldlmtkmkpypkhsjymplonmuvbfpdqfii7ezu6b23utwqtba"
	create_vnic_details {
		assign_private_dns_record = "true"
		assign_public_ip = "true"
		subnet_id = "ocid1.subnet.oc1.phx.aaaaaaaaq55t2rs7mkt3pk5paxehlynvha65fpc7nukuupbxtybs55kya7wq"
	}
	display_name = "instance-20230526-1038"
	instance_options {
		are_legacy_imds_endpoints_disabled = "false"
	}
	metadata = {
		"ssh_authorized_keys" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJfejZLH4u9kS7qIIskMS+IhyH9nSkX4PlziPiFifzs3 sdake-3\nssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIK3yb3nTxhMJHLyHx7lnjZANGsqCW5OBb49eR+aAzlS sdake-1\nssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJPMdijz8pDmtgsUBiYGFE+t7HGNkmmLb3CrFthNXxTO robert@kumul.us"
	}
	shape = "BM.GPU.A10.4"
	source_details {
		source_id = "ocid1.image.oc1.phx.aaaaaaaaklwuisblgvnmgc5sx3izwafyybksmxgavfctykpfxdhr3et3bn4a"
		source_type = "image"
	}
}
