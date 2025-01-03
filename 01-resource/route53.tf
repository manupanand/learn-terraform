resource "aws_instance" frontend" {
  ami           = "ami-0fd05997b4dff7aac"
  instance_type = "t3.micro"
  vpc_security_group_ids=["sg-0a98a718c2de79dee"]

  tags = {
    Name = "frontend.dev"
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.primary.zone_id #hosted zone id
  name    = "frontend.dev.example.online"
  type    = "A"
  ttl     = 15
  records = [aws_instance.frontend.private_ip]#resource is aws_instance
}