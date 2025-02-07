resource "aws_instance" "web_local"{
    instance_type="t3.micro"
    ami="ami-0d81f2cd09b410166"
    vpc_security_group_ids = ["sg-00ac6f603cfd19030"]
    tags={
        Name="demo-terraform"
    }
}
resource "aws_route53_record" "frontend" {
  zone_id = ""
  name    = "frontend.dev.manupanand.online"
  type    = "A"
  ttl     = 25
  records = [aws_instance.web_local.private_ip]
}

output "instance_private_ip" {
  value=aws_instance.web_local.private_ip
}