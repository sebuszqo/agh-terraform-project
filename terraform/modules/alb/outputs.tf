output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.this.dns_name
}
