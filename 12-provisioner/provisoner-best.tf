resource "aws_instance" "instance" {
   for_each = var.components
   ami=data.aws_ami.ami.image_id
   instance_type = each.value["instance_type"]
   vpc_security_group_ids = data.aws_security_groups.sg.ids
   tags = {
     Name="${each.key}.dev"
   }
}
resource "aws_route53_record" "dns_record" {
  for_each = var.components
  zone_id = data.aws_route53_zone.zone.zone_id
  name="${each.key}.dev.${var.domain_name}"
  type = A
  ttl = 15
  records = [aws_instance.instance[each.key].private_ip]


}
#use of null resource
resource "null_resource" "ansible" {
    # if only after dn records created use depends on
    depends_on = [ aws_route53_record.dns_record ]
    for_each = var.components
  provisioner "remote-exec" {
      connection {
        user = "ec2-user"
        password = "password"
        host = aws_instance.instance[each.key].private_ip
      }
      inline = [ 
               "sudo pip-3.11 install ansible",
               "ansible-pull -i localhost, -U https://github.com/username/repo main.yml -e env=dev -e role_name=${each.key}"# if in loop {each.key}
       ]
    }
}