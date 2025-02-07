
resource "aws_instance" "frontend"{
    instance_type = var.instance_type
    ami = var.ami
    vpc_security_group_ids = [ var.security_group_id]
    tags={
        Name="frontend.dev"
    }
}
resource "aws_route53_record" "frontend" {
  zone_id = var.zone_id
  name    = "frontend.dev.${var.domain_name}"
  type    = "A"
  ttl     = 25
  records = [aws_instance.web_local.private_ip]
} 