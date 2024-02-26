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

variable "instance_role_managed_policies" {
  description = "Managed policies for instance role"
  type        = set(string)
  default     = ["arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"]
}

variable "instance_role_max_session_duration" {
  description = "Max session duration for instance role"
  type        = number
  default     = 3600
}

# Launch template configuration
variable "lt_ec2_default_version" {
  description = "Launch Template EC2 default version"
  type        = number
  default     = null
}

variable "lt_ec2_disable_api_stop" {
  description = "Launch Template EC2 disable_api_stop"
  type        = bool
  default     = false
}

variable "lt_ec2_disable_api_termination" {
  description = "Launch Template EC2 disable_api_termination"
  type        = bool
  default     = false
}

variable "lt_ec2_image_id" {
  description = "Launch Template EC2 image_id"
  type        = string
  default     = "ami-0e76718e8327a9cd3"
}

variable "lt_ec2_instance_type" {
  description = "Launch Template EC2 instance_type"
  type        = string
  default     = "t2.medium"
}

variable "lt_ec2_key_name" {
  description = "Launch Template EC2 key_name"
  type        = string
  default     = "ec2-ecs-cluster-kp"
}

variable "lt_ec2_user_data" {
  description = "Launch Template EC2 user_data"
  type        = string
  default     = null
}

variable "lt_ec2_vpc_security_group_ids" {
  description = "Launch Template EC2 vpc_security_group_ids"
  type        = set(string)
  default     = []
}

# variable "lt_ec2_block_device_mappings" {
#   description = "Launch Template EC2 block_device_mappings"
#   type        = list(object({
#     device_name = string
#     ebs = object({
#       volume_size = number
#       volume_type = string
#     })
#   }))
#   default     = []
# }


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

