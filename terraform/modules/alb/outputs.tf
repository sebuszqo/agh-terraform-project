output "lb_security_group_id" {
  value = aws_security_group.lb_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.this.dns_name
}
