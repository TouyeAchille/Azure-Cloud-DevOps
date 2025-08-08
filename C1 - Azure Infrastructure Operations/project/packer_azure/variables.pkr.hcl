variable "location" {
  type        = string
  description = "The Azure region where resources will be created"
  default     = "South Central US"

}

variable image_offer {
  type = string
  description = "Name of the publisher's offer to use for your base image (Azure Marketplace Images only)"
  default = "UbuntuServer"
}

variable image_publisher {
    type = string 
    description ="Name of the publisher to use for your base image (Azure Marketplace Images only)"
    default = "canonical"
}

variable image_sku {
    type = string
    description="SKU of the image offer to use for your base image (Azure Marketplace Images only)"
    default="18.04-LTS"
}

variable image_version {
    type = string
    description=""
    default="latest"
}
variable os_type {
    type = string
    description="if either Linux or Windows"
    default="Linux"
}

variable "resource_group_name" {
  type        = string
  description = "The name of existing azure resources group" 
  default = "Azuredevops"

}

variable client_id {
    type = string
    description=" if you are using a service principal, this is the client id"
    sensitive = true
}

variable client_secret {
    type = string
    description="if you are using a service principal, this is the secret"
    sensitive = true
}
variable tenant_id {
    type = string
    description="if you are using a service principal, this is the tenant id"
    sensitive = true
}
variable subscription_id {
    type = string
    description=" if you are using a service principal, this is the subscription id"
    sensitive = true
}