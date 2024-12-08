module "network" {
  source     = "./modules/network"
  cidr_block = "10.0.0.0/16"
  name       = "Project VPC"
}

module "bastion" {
  source    = "./modules/bastion"
  subnet_id = module.network.bastion_subnet
  vpc_id = module.network.vpc_id
}