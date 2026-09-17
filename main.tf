locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
}


module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "compute" {
  source = "./modules/compute"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.vpc.vpc_id

  public_subnet_ids = module.vpc.public_subnet_ids

  ec2_security_group_id = module.security.ec2_security_group_id

  alb_security_group_id = module.security.alb_security_group_id

  instance_profile_name = module.iam.ec2_instance_profile_name

  instance_type = "t3.micro"

  db_endpoint = module.rds.db_endpoint
  db_name     = module.rds.db_name
  db_username = var.db_username
}
module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  rds_security_group_id = module.security.rds_security_group_id

  db_username = var.db_username
  db_password = var.db_password
}

