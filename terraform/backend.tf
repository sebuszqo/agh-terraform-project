terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0" # Określ wersję, której chcesz używać
    }
  }

  backend "s3" {
    bucket         = "terraform-backend-us-east-1-agh"
    key            = "cluster-dev-us-east1/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}
