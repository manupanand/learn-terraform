
resource "aws_instance" "instance"{
    count=length(var.components)
    instance_type = var.instance_type
    ami = data.aws_ami.ami-data.image_id
    vpc_security_group_ids =  data.aws_security_groups.security_group.ids
    tags={
        Name="${var.components[count.index]}.dev"
    }
}
resource "aws_route53_record" "dns_record" {
  count=length(var.components)
  depends_on = [ aws_instance.instance ]
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${var.components[count.index]}.dev.${var.domain_name}"
  type    = "A"
  ttl     = 25
  records = [aws_instance.instance[count.index].private_ip]
} 
