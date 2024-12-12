output "bastion_public_ip" {
  value       = module.bastion.bastion_public_ip
  description = "Public IP address of the bastion instance"
}

output "load_balancer_dns" {
  description = "DNS of the Load Balancer"
  value       = module.alb.dns_name
}

output "app_ips" {
  description = "App instances private IPs"
  value       = [for ip in module.app.private_ips : ip]
}

output "ssh_config_bastion" {
  description = "SSH configuration for Bastion. Add this to: ~/.ssh/config"
  value = join("\n", [
    "  Host bastion",
    "  HostName ${module.bastion.bastion_public_ip}",
    "  User ec2-user",
    "  IdentityFile ~/.ssh/bastion_agh"
  ])
}

output "ssh_config_app" {
  description = "SSH configuration for private EC2 instances. Add this to: ~/.ssh/config"
  value = join("\n", [
    for i, ip in module.app.private_ips : "  Host instance-${i}\n  HostName ${ip}\n  User ec2-user\n  IdentityFile ~/.ssh/app_agh\n  ProxyJump bastion\n"
  ])
}


# output "db_endpoint" {
#   value = module.rds.db_endpoint
# }