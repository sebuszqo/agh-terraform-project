variable "instance_count" {
  type    = number
  default = 2
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the instances"
  default     = "ami-064519b8c76274859"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t2.micro"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the instances"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "app_security_group_id" {
  type        = string
  description = "Security Group ID for App"
}

variable "target_group_arn" {
  type        = string
  description = "ALB Target Group ID"
}

