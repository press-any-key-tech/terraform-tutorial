
# The home of the variables
variable "tags" {
  description = "External tags map"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "Set the primary region"
  type        = string
  default     = "eu-west-1"
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

variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
  default     = "default"
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
