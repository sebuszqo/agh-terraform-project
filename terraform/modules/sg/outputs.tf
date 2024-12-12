output "bastion_sg_id" {
  description = "Security Group ID for Bastion Host"
  value       = aws_security_group.bastion.id
}

output "lb_sg_id" {
  description = "Security Group ID for Load Balancer"
  value       = aws_security_group.lb_sg.id
}

output "app_sg_id" {
  description = "Security Group ID for Application"
  value       = aws_security_group.app_sg.id
}

output "rds_sg_id" {
  description = "Security Group ID for RDS"
  value       = aws_security_group.rds_sg.id
}
