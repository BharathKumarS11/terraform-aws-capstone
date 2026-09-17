output "launch_template_id" {
  value = aws_launch_template.app.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.app.name
}

output "load_balancer_dns_name" {
  value = aws_lb.app.dns_name
}

output "load_balancer_arn" {
  value = aws_lb.app.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}