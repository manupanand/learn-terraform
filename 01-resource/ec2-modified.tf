variable "ami"{
    default="ami-0fd05997b4dff7aac"
}
variable "instance_type"{
    default="t3.micro"
}
variable "security_group_id"{
    default=["sg-0a98a718c2de79dee"]
}
# variable "domain_name"{
#     default="example.online"
# }

resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids=var.security_group_id

  tags = {
    Name = "test-terraform.dev"
  }
}


resource "aws_instance" "frontend" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids=var.security_group_id

  tags = {
    Name = "frontend.dev"
  }
}

# resource "aws_route53_record" "frontend" {
#   zone_id = aws_route53_zone.primary.zone_id #hosted zone id
#   name    = "frontend.dev.${var.domain_name}"
#   type    = "A"
#   ttl     = 15
#   records = [aws_instance.frontend.private_ip]#resource is aws_instance
# }
# using data

resource "aws_instance" "frontend" {
  ami           = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids=data.aws_security_groups.sg.ids

  tags = {
    Name = "frontend.dev"
  }
}