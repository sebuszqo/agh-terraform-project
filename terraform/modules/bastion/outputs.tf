output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
  description = "Public IP address of the bastion instance"
}

output "bastion_security_group_id" {
  value = aws_security_group.bastion.id
}