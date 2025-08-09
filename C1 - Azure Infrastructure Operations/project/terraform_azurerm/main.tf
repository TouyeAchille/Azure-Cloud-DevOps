# file that contains all resource and data source blocks #

# using existing resource group on a
data "azurerm_resource_group" "rg" {
  name = "Azuredevops"
}

# using existing image on azure
data "azurerm_image" "packer_image" {
  name                = "UbuntuServer-18.04-LTS"
  resource_group_name = data.azurerm_resource_group.rg.name

}


# create virtual network on azure (vnet)
resource "azurerm_virtual_network" "vnet" {
  name                = "${data.azurerm_resource_group.rg.name}-vnet"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/24"]
  tags                = { "environment" : "vnet" }
}



resource "azurerm_subnet" "subnet" {
  name                 = "${data.azurerm_resource_group.rg.name}-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]


}


resource "azurerm_network_interface" "nic" {
  count               = var.counter
  name                = "${data.azurerm_resource_group.rg.name}-nic${count.index}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = { "environment" : "nic${count.index}" }

}

resource "azurerm_linux_virtual_machine" "vm" {
  count                           = var.counter
  name                            = "${data.azurerm_resource_group.rg.name}-vm${count.index}"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  size                            = "Standard_D2s_v3"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  source_image_id = data.azurerm_image.packer_image.id

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    "environment" : "vm${count.index}"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${data.azurerm_resource_group.rg.name}-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "DenyInboundInternet"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
    description                = "Block any inbound traffic from the Internet"
  }

  security_rule {
    name                       = "AllowVnetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
    description                = "Allow internal communication between VMs in the VNet"
  }

  tags = {
    "environment" : "NetworkSecurityGroup"
  }

}

resource "azurerm_subnet_network_security_group_association" "nsg" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "public_ip" {
  name                = "Deny${data.azurerm_resource_group.rg.name}-public_ip"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Static"

  tags = { environment = "Public_ip" }
}


resource "azurerm_lb" "lb" {
  name                = "${data.azurerm_resource_group.rg.name}-lb"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "Publicloadbalancer"
    public_ip_address_id = azurerm_public_ip.public_ip.id

  }
  tags = { "environment" : "loadbalancer" }
}

resource "azurerm_lb_backend_address_pool" "lb_address_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_backend_address_pool" {
  count                   = var.counter
  network_interface_id    = azurerm_network_interface.nic[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_address_pool.id
}