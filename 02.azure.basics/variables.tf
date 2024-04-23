
# The home of the variables
variable "tags" {
  description = "External tags map"
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "Set the primary location"
  type        = string
  default     = "westeurope"
}

variable "environment" {
  description = "Set environment name"
  type        = string
  default     = ""
}

variable "cost_center" {
  description = "Cost center associated with the project"
  type        = string
  default     = ""
}

variable "project" {
  description = "Project name"
  type        = string
  default     = ""
}

variable "resource_group" {
  description = "Resource group name"
  type        = string
  default     = ""
}

variable "vnet_name" {
  description = "Virtual network name"
  type        = string
  default     = ""
}

variable "vnet_cidr_blocks" {
  description = "Virtual network CIDR"
  type        = list(string)
  default     = []
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = ""
}

variable "subnet_cidr_blocks" {
  description = "Subnet CIDR blocks"
  type        = list(string)
  default     = []
}

variable "nic_name" {
  description = "Network interface name"
  type        = string
  default     = ""
}

variable "nic_ip_configuration_name" {
  description = "Network interface IP configuration name"
  type        = string
  default     = ""
}

variable "vm_name" {
  description = "Virtual machine name to use"
  type        = string
  default     = "terraform-test"
}

variable "vm_size" {
  description = "Virtual machine size to use"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username to use"
  type        = string
  default     = "adminuser"
}



variable "instance_type" {
  description = "Instance type to use"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Instance name to use"
  type        = string
  default     = "terraform-test"
}

variable "instance_image" {
  description = "Instance AMI"
  type        = string
  default     = "ami-0fef2f5dd8d0917e8"
}

variable "instance_key_name" {
  description = "Instance key name to use"
  type        = string
  default     = "aws-test-key"
}

variable "prefix" {
  description = "Prefix to add to all the services"
  type        = string
  default     = "default"
}
