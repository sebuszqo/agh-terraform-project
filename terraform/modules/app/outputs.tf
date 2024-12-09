output "instance_ids" {
  description = "IDs of instances in the Auto Scaling Group"
  value       = data.aws_instances.app_instances.ids
}

output "private_ips" {
  description = "Private IPs of instances in the Auto Scaling Group"
  value       = data.aws_instances.app_instances.private_ips
}
