variable "environment" {
  description = "Set environment name"
  type        = string
  default     = ""
}

variable "project_id" {
  description = "Google project ID"
  type        = string
  default     = ""
}

variable "service_name" {
  description = "Cloud Run Service name"
  type        = string
  default     = null
}

variable "service_location" {
  description = "Cloud Run Service location"
  type        = string
  default     = "us-central1"

}

variable "image" {
  description = "Cloud Run Service image"
  type        = string
  default     = null
}

variable "traffic_percent" {
  description = "Cloud Run Service traffic percent"
  type        = number
  default     = 100
}

variable "container_concurrency" {
  description = "Cloud Run Service container concurrency"
  type        = number
  default     = 80
}

variable "limits_cpu" {
  description = "Cloud Run Service limits cpu"
  type        = string
  default     = "1000m"
}

variable "limits_memory" {
  description = "Cloud Run Service limits memory"
  type        = string
  default     = "256Mi"
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

variable "vpc_subnets_ids" {
  description = "Cluster subnets"
  type        = set(string)
  default     = []
}


variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default     = 1
}

