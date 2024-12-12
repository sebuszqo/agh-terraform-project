variable "subnet_id" {
  description = "Subnet ID for bastion host"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "bastion_security_group_id" {
  type        = string
  description = "Security Group ID for Bastion"
}