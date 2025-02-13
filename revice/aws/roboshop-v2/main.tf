
resource "aws_instance" "instance"{
   for_each = var.components
    instance_type = each.value["instance_type"]
    ami = data.aws_ami.ami-data.image_id
    vpc_security_group_ids = data.aws_security_groups.security_group.ids
    tags={
        Name="${each.key}.dev"
    }
}
resource "aws_route53_record" "dns_record" {
  for_each = var.components
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${each.key}.dev.${var.domain_name}"
  type    = "A"
  ttl     = 25
  records = [aws_instance.instance[each.key].private_ip]
} 