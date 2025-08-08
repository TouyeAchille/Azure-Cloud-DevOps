# file that contains all variable blocks #

variable "admin_username" {
  type        = string
  description = "The admin username for the VM being created."
  default     = "mbogolta"
}

variable "admin_password" {
  type        = string
  description = "The password for the VM being created."
  sensitive   = true
}

variable "counter" {
  type        = number
  description = "number of  nic or vm, for main vnet"
  default     = 2
}

