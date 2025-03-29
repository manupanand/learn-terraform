variable "repos" {
  default = {
    "ecomm-cart"={},
    "ecomm-catalogue"={},
    "ecomm-payment"={},
    "ecomm-shipping"={},
    "ecomm-user"={},
    "ecomm-frontend"={},

  }
}

variable "env" {
  default ={ "DEV"={},
                "QA"={},
                "UAT"={},
                "PROD"={}}
}
locals{
    repos_with_envs={for i,j in var.repos: i =>{for x,y in var.env: "${i}_${x}"=> {"env"=x,"app"=i}}}
}
output "map" {
#   value=values(local.repos_with_envs)#values function bring values only
value =flatten([for a,b in local.local.repos_with_envs: values(b)])
}