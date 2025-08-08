/* file that contains a single terraform block which defines 
   your required_version and required_providers 
*/

# Azure Provider source and version being used
terraform {
  required_version = ">=v1.12.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.37.0"
    }
  }
}