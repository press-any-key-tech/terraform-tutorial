variable "environment" {
  description = "Set environment name"
  type        = string
  default     = ""
}

variable "name" {
  description = "Namespace name"
  type        = string
  default     = null
}

variable "description" {
  description = "Namespace description"
  type        = string
  default     = "Namespace for ECS services"
}


variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC for the Cluster"
  type        = string
  default     = null
}

