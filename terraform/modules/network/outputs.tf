output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "bastion_subnet" {
  value = aws_subnet.bastion.id
}

output "private_ec2_subnets" {
  value = aws_subnet.private_ec2[*].id
}

output "private_rds_subnets" {
  value = aws_subnet.private_rds[*].id
}

output "vpc_id" {
  value = aws_vpc.this.id
}
