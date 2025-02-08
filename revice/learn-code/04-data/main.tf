data "aws_ami" "ami-data"{
    most_recent = true
    name_regex = "al2023-ami-2023.6.20250128.0-kernel-6.1-x86_64"
    owners = ["140264529686"]
}

output "ami"{
    value=data.aws_ami.ami-data
  }

#security group VPC
data "aws_security_groups" "security_group"{
    filter {
      name="group-name"
      values=["ssh-ngrok"]
    }
}
output "sg_name" {
  value= data.aws_security_groups.security_group
}

#route 53 zone id
data "aws_route53_zone" "zone"{
    name= var.domain_name
    
}
variable "domain_name"{
    default = "manupanand.online"
}
output "route_zone_id" {
  value = data.aws_route53_zone.zone
}