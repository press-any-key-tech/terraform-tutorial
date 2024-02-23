variable "environment" {
  description = "Set environment name"
  type        = string
  default     = ""
}

variable "lb_name" {
  description = "Load balancer name"
  type        = string
  default     = null
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "mailhog"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Subnet IDs for the load balancer"
  type        = set(string)
  default     = []
}


variable "listener_port" {
  description = "Port exposed by the load balancer"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol for the listener"
  type        = string
  default     = "HTTP"
}
