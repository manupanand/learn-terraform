resource "aws_instance" "instace" {
  count = length(var.components)
  ami = data.aws_ami.ami.image_id
  instance_type = var.instace_type
  vpc_security_group_ids = data.aws_security_groups.sg.ids

  tags = {
    Name="${var.components[count.index]}.dev"
  }
}
resource "aws_route53_record" "dns_record" {
    count = length(var.components)
  zone_id =data.aws_route53_zone.zone.zone_id
  #data.aws_route53_zone.zone.zone_id
   #hosted zone id
  name    = "${var.components[count.index]}.dev.${var.domain_name}"
  type    = "A"
  ttl     = 15
  records = [aws_instance.instance[count.index].private_ip]#resource is aws_instance
}