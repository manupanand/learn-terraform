data "aws_ami" "ami"{
    # executable_users=["self"]
    most_recent=true
    name_regex="ami-021e165d8c4ff761d"
    owners = ["137112412989"]#owner number
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