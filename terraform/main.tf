module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  environment        = var.environment
}

module "security" {
  source = "./modules/Security"
  
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
}

module "alb" {
  source = "./modules/ALB"
  
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.security.security_group_id
  public_subnets    = module.vpc.public_subnet_ids
  environment       = var.environment
}

module "ecs" {
  source = "./modules/ECS"
  
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.security.security_group_id
  public_subnets    = module.vpc.public_subnet_ids
  target_group_arn  = module.alb.target_group_arn
  environment       = var.environment
  container_port    = var.container_port
}