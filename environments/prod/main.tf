module "networking" {
  source = "../../modules/vpc"

  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  azs         = var.azs
}

module "security" {
  source = "../../modules/security-groups"

  environment = var.environment
  vpc_id      = module.networking.vpc_id
}

module "compute" {
  source = "../../modules/ec2"

  environment     = var.environment
  vpc_id          = module.networking.vpc_id
  public_subnets  = module.networking.public_subnets
  private_subnets = module.networking.private_subnets
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = module.security.security_groups
  min_size        = 3
  max_size        = 6
  desired_size    = 3
}

module "database" {
  source = "../../modules/rds"

  environment    = var.environment
  vpc_id         = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  db_instance_class = var.db_instance_class
  db_name        = var.db_name
  db_username    = var.db_username
  security_groups = module.security.security_groups
  multi_az       = true
  backup_retention_period = 30
}

module "load_balancer" {
  source = "../../modules/alb"

  environment    = var.environment
  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnets
  security_groups = module.security.security_groups
  target_instances = module.compute.instance_ids
}

module "iam" {
  source = "../../modules/iam"

  environment = var.environment
  account_id  = var.account_id
}