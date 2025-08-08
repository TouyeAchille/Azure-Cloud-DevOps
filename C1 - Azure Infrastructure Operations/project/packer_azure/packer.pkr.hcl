packer {
  required_version = ">=v1.13.1"
  required_plugins {
    azurerm = {
      version = ">=v2.3.3"
      source  = "github.com/hashicorp/azure"
    }
  }
}
