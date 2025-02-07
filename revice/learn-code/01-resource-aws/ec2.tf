resource "aws_instance" "web_local"{
    instance_type="t3.micro"
    ami="ami-0d81f2cd09b410166"
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