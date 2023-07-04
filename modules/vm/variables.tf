variable "resource_group_name" {
    type        = string
    description     = "Name of resource group"
}

variable "location" {
    type            = string
    description     = "Location of resource group"
    default         = "Uk South"
}

variable "vn_name" {
    type        = string
    description     = "Name of virtual network"
}

variable address_space {
    type        = list(string)
    description     = "virtual network address"
}

variable sn_name {
    type        = string
    description     = "Name of subnet"
}

variable address_prefixes{
    type        = list(string)
    description = "Subnet address"
}

variable pip_name {
    type        = string
    description     = "Name of public IP"
}

variable vm_name {
    type        = string
    description     = "Name of virtual machine"
}

variable username {
    type        = string
    description     = "Name of account user"
}

variable nsg_name {
    type        = string
    description     = "Name of network security group"
}

variable vm_count {
    type        = number
    description = "Number of VMs to create"
}
