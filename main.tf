terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.62.1"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features{}
}


module presh-vm {
  source                = "./modules/vm"
  resource_group_name   = "pee"
  vn_name               = "pee-vn"
  address_space         = ["10.0.0.0/16"]
  sn_name               = "pee-sn"
  address_prefixes      = ["10.0.1.0/24"]
  pip_name              = "pee-pip"
  vm_count                 = 2
  vm_name               = "pee-vm"
  username              = "pee"
  nsg_name              = "pee-nsg"
}

output "public_ip" {
  value = module.presh-vm.multiple_ip
}
/* 
output "private_ip" {
  value = module.presh-vm.private_ip[count.index]
} */

output "private_ip" {
  value = module.presh-vm.multiple_pip
}
