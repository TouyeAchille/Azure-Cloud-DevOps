source "azure-arm" "ubuntu" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  image_offer                       = var.image_offer
  image_publisher                   = var.image_publisher
  image_sku                         = var.image_sku
  image_version                     = var.image_version
  location                          = var.location
  managed_image_name                = "${var.image_offer}-${var.image_sku}"
  managed_image_resource_group_name = var.resource_group_name
  os_type                           = var.os_type
  vm_size                           = "Standard_DS2_v2"
  azure_tags                         = { "environment" = "packerimage" }
}