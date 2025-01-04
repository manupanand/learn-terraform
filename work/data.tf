data "aws_ami" "ami"{
    executable_users=["self"]
    most_recent=true
    name_regex="AMI name"
    owners = ["619494949"]#owner number
}
data "aws_security_groups" "sg"{
    filter {
        name = "group-name"
        values=["nginx-loadbalacer"]
    }
}
data "aws_route53_zone" "zone"{
    name=var.domain_name
}