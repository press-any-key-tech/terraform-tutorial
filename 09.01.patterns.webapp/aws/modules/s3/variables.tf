
variable "bucket_name" {
  description = "Bucket name"
  type        = string
  default     = null
}

variable "environment" {
  description = "Set environment name"
  type        = string
  default     = ""
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

variable "block_public_access" {
  description = "Indicate if the bucket will have public access"
  type        = bool
  default     = false
}

variable "enable_website_hosting" {
  description = "Indicate if website hosting should be configured"
  type        = bool
  default     = true
}
