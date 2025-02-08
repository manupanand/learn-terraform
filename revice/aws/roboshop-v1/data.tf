data "aws_ami" "ami-data"{
    most_recent = true
    name_regex = "al2023-ami-2023.6.20250128.0-kernel-6.1-x86_64"
    owners = ["140264529686"]
}

#security group VPC
data "aws_security_groups" "security_group"{
    filter {
      name="group-name"
      values=["ssh-ngrok"]
    }
}

#route 53 zone id
data "aws_route53_zone" "zone"{
    name= var.domain_name
    
}