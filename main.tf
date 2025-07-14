module "networking" {
  source               = "./modules/networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  cidr_private_subnet  = var.cidr_private_subnet
  availability_zones   = var.availability_zones
}

module "iam" {
  source = "./modules/iam"
}

module "compute" {
  source                = "./modules/compute"
  private_subnet_ids    = module.networking.private_subnet_ids
  alb_sg_id             = module.networking.alb_sg_id
  web_sg_ids            = [module.networking.web_sg_id]
  key_name              = var.key_name
  vpc_id                = module.networking.vpc_id
  instance_profile_name = module.iam.ec2_instance_profile_name
}

module "db" {
  source             = "./modules/db"
  private_subnet_ids = module.networking.private_subnet_ids
  db_username        = var.db_username
  db_password        = var.db_password
  db_sg_id           = module.networking.db_sg_id
}

module "monitoring" {
  source  = "./modules/monitoring"
  alb_arn = module.compute.alb_arn
}

