
 variable "name" {
  
 }
variable "instance_type" {
  
}
variable "allow_port" {
  
}
variable "allow_sg_cidr" {
  
}
variable "subnet_ids" {
  
}
variable "vpc_id" {
  
}
variable "env" {
  
}
variable "bastion_nodes" {
  
}
# variable "capacity" {
#   default = {}#db no nned to asg , but using same ec2 so put some default value
# }
# variable "asg" {
  
# }
variable "vault_token" {
  
}
variable "zone_id" {
  
}
# variable "internal" {
#   default= null #because db aso use same module too avoid error
# }
# variable "lb_subnet_ids" {
#   #subnet ref as public or app
#   default = []
# }
# variable "allow_lb_sg_cidr" {
#   default = []
# }