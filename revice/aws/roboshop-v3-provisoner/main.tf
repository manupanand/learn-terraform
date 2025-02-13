
resource "aws_instance" "instance"{
   for_each = var.components
    instance_type = each.value[instance_type]
    ami = data.aws_ami.ami-data.image_id
    vpc_security_group_ids = [ data.aws_security_groups.security_group.ids]
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

resource "null_resource" "ansible" {
  depends_on = [ aws_route53_record.dns_record ]#exclusively run after dnr records are created
  for_each = var.components
  #since provisoner giving inside the resource block will recreate resource agin if provisoner is failure
    provisioner "remote-exec" {
      connection {
        user="ec2-user"
        password="password"
        host = aws_instance.instance[each.key].private_ip
      }
      # commands to run -ec to do some ansible pull

      inline = [ 
        "sudo pip3.12 install ansible",
        "ansible-pull -i localhost, -U https://github.com/username/repo playbook.yaml -e role_name=${each.key}"
       ]
    }
}