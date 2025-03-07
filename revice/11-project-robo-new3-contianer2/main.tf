module "vpc" {
  source = "./modules/vpc"

  cidr = var.vpc["cidr"]
  env  = var.env
  public_subnets=var.vpc["public_subnets"]
  web_subnets=var.vpc["web_subnets"]
  app_subnets=var.vpc["app_subnets"]
  db_subnets=var.vpc["db_subnets"]
  availability_zones= var.vpc["availability_zones"]
  default_vpc_id=var.vpc["default_vpc_id"]
  default_vpc_rt=var.vpc["default_vpc_rt"]
  default_vpc_cidr=var.vpc[" default_vpc_cidr"]
}
# module "apps" { #module is named as app becuase, db will be same but no ned to austo scaling group
#   # terraform soesnt follow order to proceed
#   depends_on = [ module.db, module.vpc ]
#   source = "./modules/asg"
  
#   for_each = var.apps
#   name = each.key
#   instance_type = each.value["instance_type"]
#   allow_port = each.value["allow_port"]
#   allow_sg_cidr=each.value["allow_sg_cidr"]
#   subnet_ids= module.vpc.subnets[each.value["subnet_ref"]]
#   capacity = each.value["capcity"]
#   vpc_id =module.vpc.vpc_id
#   env= var.env
#   bastion_nodes=var.bastion_nodes
#   asg= true
#   vault_token = var.vault_token
#   zone_id = var.zone_id
#   # internal= each.value["lb_internal"]
#   # lb_subnet_ids=module.vpc.subnets[each.value["lb_subnet_ref"]]
#   # allow_lb_sg_cidr=each.value["allow_lb_sg_cidr"]
#   # acm_https_arn=each.value["acm_https_arn"]
#   dns_name = module.load-balancers[each.value["lb_ref"]].dns_name # two dns private and public
#   listener_arn = module.load-balancers[each.value["lb_ref"]].listener_arn
#   lb_rule_priority = each.value["lb_rule_priority"]

# }
# module "db" { #module is named as app becuase, db will be same but no ned to austo scaling group
#   depends_on = [ module.vpc ]
#   source = "./modules/ec2"
#   # no need of autoscaling group
#   for_each = var.db
#   name = each.key
#   instance_type = each.value["instance_type"]
#   allow_port = each.value["allow_port"]
#   allow_sg_cidr=each.value["allow_sg_cidr"]
#   subnet_ids= module.vpc.subnets[each.value["subnet_ref"]]
#   # capacity = each.value["capcity"]
#   vpc_id =module.vpc.vpc_id
#   env= var.env
#   bastion_nodes=var.bastion_nodes
#   # asg= false
#   vault_token = var.vault_token# in github actions
#   zone_id = var.zone_id

# }
# module "load-balancers" {
#   source              = "./modules/load-balancer"
#   for_each            =  var.load_balancers
#   name                = each.key
#   allow_lb_sg_cidr    = each.value["allow_lb_sg_cidr"]
#   internal            = each.value["internal"]
#   load_balancer_type  = each.value["load_balancer_type"]
#   env                 = var.env
#   vpc_id              = module.vpc.vpc_id
#   subnet_ids          = module.vpc.subnets[each.value["subnet_ref"]]
#   acm_https_arn       =each.value["acm_https_arn"]
#   listener_port       = each.value["listener_port"]
#   listener_protocol   = each.value["listener_protocol"]
#   ssl_policy          = each.value["ssl_policy"]
# }

module "eks" {
  depends_on = [ module.vpc ]
  source = "./modules/eks"
  env=var.env
  subnet_ids = module.vpc.app_subnet_ids
  node_groups = var.eks["node_groups"]
  eks_version = var.eks["eks_version"]
  add_ons= var.eks["add_ons"]
  eks-iam-access=var.eks["eks-iam-access"]
}