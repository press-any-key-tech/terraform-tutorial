variable "environment" {
  description = "Set environment name"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = null
}

variable "project" {
  description = "Project name"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC for the services"
  type        = string
  default     = null
}

variable "vpc_subnets_ids" {
  description = "Services subnets"
  type        = set(string)
  default     = []
}

variable "alb_arn" {
  description = "ARN of the Application Load Balancer"
  type        = string
  default     = null
}

variable "logs_group_arn" {
  description = "ARN of the Logs group"
  type        = string
  default     = null
}

variable "service_name" {
  description = "Service name"
  type        = string
  default     = null
}










variable "task_cpu" {
  description = "Task assigned CPU"
  type        = string
  default     = "1024"
}

variable "task_memory" {
  description = "Task assigned Memory"
  type        = string
  default     = "2048"
}

variable "task_requires_compatibilities" {
  description = "Compatibility"
  type        = list(string)
  default     = ["EC2"]
}

variable "http_task_container_definitions" {
  description = "Container definitions for http"
  type        = string
  default     = null
}

variable "websockets_task_container_definitions" {
  description = "Container definitions for websockets"
  type        = string
  default     = null
}


variable "task_definition_family" {
  description = "Task definition family"
  type        = string
  default     = null
}





# #############################################################################
# SSM variables
# #############################################################################

variable "aws_kms_ssm_default_key" {
  description = "Default key that protects my SSM parameters when no other key is defined"
  type        = string
  default     = null
}


variable "tasks" {
  description = "A list of tasks"
  type = list(object({
    container_definition     = string
    name                     = string
    cpu                      = string
    family                   = string
    memory                   = string
    container_name           = string
    port                     = number
    min_capacity             = number
    max_capacity             = number
    logs_group_arn           = string
    health_check_path        = string
    health_check_status_code = string
    health_check_protocol    = string
    # subdomain                = string
    path = string

  }))
  default = []
}


variable "certificate_arn" {
  description = "ACM certificate arn"
  type        = string
  default     = null
}

variable "load_balancer_port" {
  description = "Load balancer exit port"
  type        = number
  default     = 80
}


variable "lb_listener_arn" {
  description = "ARN of the listener"
  type        = string
  default     = null
}

variable "listener_rule_priority_base" {
  description = "Listener rule priority base"
  type        = number
  default     = 100
}


