resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.name
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, 4, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index}"
  }
}

resource "aws_subnet" "bastion" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, 4, 2)
  availability_zone       = element(data.aws_availability_zones.available.names, 0)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Bastion Subnet"
  }
}

resource "aws_subnet" "private_ec2" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, 4, count.index + 4)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "Private EC2 Subnet ${count.index}"
  }
}

resource "aws_subnet" "private_rds" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, 4, count.index + 6)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "Private RDS Subnet ${count.index}"
  }
}