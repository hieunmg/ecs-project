output "id" {
  value       = aws_lb.load_balancer.id
  description = "ID of the load balancer"
}

output "dns_name" {
  value       = aws_lb.load_balancer.dns_name
  description = "DNS name of the load balancer"
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}
