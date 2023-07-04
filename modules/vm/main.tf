resource "azurerm_resource_group" "prg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "pvnet" {
  name                = var.vn_name
  address_space       = var.address_space
  location            = azurerm_resource_group.prg.location
  resource_group_name = azurerm_resource_group.prg.name
}

resource "azurerm_subnet" "psnet" {
  name                 = var.sn_name
  resource_group_name  = azurerm_resource_group.prg.name
  virtual_network_name = azurerm_virtual_network.pvnet.name
  address_prefixes     = var.address_prefixes
}

resource "azurerm_public_ip" "ppip" {
  count                   = var.vm_count
  name                    = "pip-${count.index}"
  location                = azurerm_resource_group.prg.location
  resource_group_name     = azurerm_resource_group.prg.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "${var.vm_name}test"
  }
}

resource "azurerm_network_interface" "pnic" {
  count               = var.vm_count
  name                = "pnic-${count.index}"
  location            = azurerm_resource_group.prg.location
  resource_group_name = azurerm_resource_group.prg.name

  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.psnet.id
    private_ip_address_allocation = "Dynamic"
    # private_ip_address            = "10.0.1.1"
    public_ip_address_id          = azurerm_public_ip.ppip[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "pvm" {
  count               = var.vm_count
  name                = "vm-${count.index}"
  resource_group_name = azurerm_resource_group.prg.name
  location            = azurerm_resource_group.prg.location
  size                = "Standard_F2"
  admin_username      = var.username
  network_interface_ids = [
    azurerm_network_interface.pnic[count.index].id,
  ]

  admin_ssh_key {
    username   = var.username
    public_key = file("key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  /* disable_license_type = true */
}

resource "azurerm_network_security_group" "pnsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.prg.location
  resource_group_name = azurerm_resource_group.prg.name
}

resource "azurerm_subnet_network_security_group_association" "pnsga" {
  subnet_id                 = azurerm_subnet.psnet.id
  network_security_group_id = azurerm_network_security_group.pnsg.id
}

resource "azurerm_network_security_rule" "example" {
  name                        = "p80"
  priority                    = 201
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.prg.name
  network_security_group_name = azurerm_network_security_group.pnsg.name
}

resource "azurerm_network_security_rule" "example2" {
  name                        = "p22"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.prg.name
  network_security_group_name = azurerm_network_security_group.pnsg.name
}
