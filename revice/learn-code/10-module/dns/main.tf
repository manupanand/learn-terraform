resource "aws_route53_record" "frontend" {
  zone_id = var.zone_id
  name    = "frontend.dev.manupanand.online"
  type    = "A"
  ttl     = 25
  records = [var.private_ip]
}
#recieve input
variable "private_ip" {
  
}
variable "zone_id"{

}