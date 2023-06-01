variable compartment_id {
    type = string
    default = "ocid1.compartment.oc1..aaaaaaaaq6xqdldlmtkmkpypkhsjymplonmuvbfpdqfii7ezu6b23utwqtba"
}

variable namespace {
    type = string
    default = "axhocnnse6ez"
}

variable availability_domain {
    type = string
    default = "zyFb:PHX-AD-1"
    #default = "zyFb:PHX-AD-3"
}
variable instance_shape {
    type = string
    # default = "VM.Standard2.1"
    default = "BM.GPU.A10.4"
}

variable bucket_name {
    type = string
    default = "debian-golden"
}

variable object_name {
    type = string
    default = "golden.raw-disk001.vmdk"
}

variable image_display_name {
    type = string
    default = "debian-golden"
}

variable image_launch_mode {
    type = string
    default = "PARAVIRTUALIZED"
}
