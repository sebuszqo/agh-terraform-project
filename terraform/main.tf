module "network" {
  source     = "./modules/network"
  cidr_block = "10.0.0.0/16"
  name       = "Project VPC"
}

module "bastion" {
  source     = "./modules/bastion"
  subnet_id  = module.network.bastion_subnet
  vpc_id     = module.network.vpc_id
  depends_on = [module.network]
}

module "alb" {
  source         = "./modules/alb"
  public_subnets = module.network.public_subnets
  vpc_id         = module.network.vpc_id
}

module "app" {
  source                    = "./modules/app"
  subnet_ids                = module.network.private_ec2_subnets
  vpc_id                    = module.network.vpc_id
  alb_security_group_id     = module.alb.lb_security_group_id
  bastion_security_group_id = module.bastion.bastion_security_group_id
  target_group_arn          = module.alb.target_group_arn
}