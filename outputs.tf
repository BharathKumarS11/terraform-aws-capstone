output "aws_region" {
  value = var.aws_region
}

output "project_name" {
  value = var.project_name
}

output "environment" {
  value = var.environment
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}

output "alb_security_group_id" {
  value = module.security.alb_security_group_id
}

output "ec2_security_group_id" {
  value = module.security.ec2_security_group_id
}

output "rds_security_group_id" {
  value = module.security.rds_security_group_id
}

output "ec2_role_name" {
  value = module.iam.ec2_role_name
}

output "ec2_role_arn" {
  value = module.iam.ec2_role_arn
}

output "ec2_instance_profile_name" {
  value = module.iam.ec2_instance_profile_name
}

output "launch_template_id" {
  value = module.compute.launch_template_id
}

output "autoscaling_group_name" {
  value = module.compute.autoscaling_group_name
}

output "load_balancer_dns_name" {
  value = module.compute.load_balancer_dns_name
}

output "load_balancer_arn" {
  value = module.compute.load_balancer_arn
}

output "target_group_arn" {
  value = module.compute.target_group_arn
}

