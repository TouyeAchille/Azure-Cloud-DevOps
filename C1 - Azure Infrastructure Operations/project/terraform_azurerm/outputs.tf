# file that contains all output blocks #

output "resource_group_name" {
  description = "The name of the created resource group."
  value       = data.azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  description = "The name of the created virtual network."
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_names" {
  description = "List of name of the created subnets."
  value       = [for snet in azurerm_subnet.subnet[*] : snet.name]
}

output "nic_names" {
  description = "List of names of the created nic"
  value       = [for nic in azurerm_network_interface.nic : nic.name]

}

output "linux_virtual_machine_names" {
  description = "List of names of the created VMs"
  value       = [for vm in azurerm_linux_virtual_machine.vm : vm.name]
}


output "nsg_name" {
  description = "the name of the nsg"
  value       = azurerm_network_security_group.nsg.name

}
output "image_id" {
  description = "The ID of the image used for the VM."
  value       = data.azurerm_image.packer_image.id
}
