
resource "aws_instance" "frontend"{
    instance_type = var.instance_type
    ami = data.aws_ami.ami-data.image_id
    vpc_security_group_ids = [ data.aws_security_groups.security_group.ids]
    tags={
        Name="frontend.dev"
    }
}
resource "aws_route53_record" "frontend" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "frontend.dev.${var.domain_name}"
  type    = "A"
  ttl     = 25
  records = [aws_instance.web_local.private_ip]
} 