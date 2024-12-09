# AGH Terraform Project

## Overview
This project manages AWS infrastructure using Terraform, including a bastion host, ec2 app instances and RDS instances and network setup (VPC, subnets, security groups).

## Quick Start
- Initialize Terraform: `make init`
- Plan changes: `make plan`
- Apply changes: `make apply`
- Destroy resources: `make destroy`
- Format terraform code: `make fmt`

## terraform-backend
This catalog creates S3 bucket that is used to store tfstate for "terraform" catalog that is main app.
