module "network" {
  source     = "./modules/network"
  cidr_block = "10.0.0.0/16"
  name       = "Project VPC"
}

module "security_groups" {
  source = "./modules/sg"
  vpc_id = module.network.vpc_id
}

module "bastion" {
  source                    = "./modules/bastion"
  subnet_id                 = module.network.bastion_subnet
  vpc_id                    = module.network.vpc_id
  bastion_security_group_id = module.security_groups.bastion_sg_id
}

module "alb" {
  source                = "./modules/alb"
  public_subnets        = module.network.public_subnets
  vpc_id                = module.network.vpc_id
  alb_security_group_id = module.security_groups.lb_sg_id
}

module "app" {
  source                = "./modules/app"
  subnet_ids            = module.network.private_ec2_subnets
  vpc_id                = module.network.vpc_id
  target_group_arn      = module.alb.target_group_arn
  app_security_group_id = module.security_groups.app_sg_id
}

module "rds" {
  source            = "./modules/db"
  vpc_id            = module.network.vpc_id
  private_subnets   = module.network.private_rds_subnets
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  db_name           = "appdb"
  app_sg_id         = module.security_groups.app_sg_id
}
