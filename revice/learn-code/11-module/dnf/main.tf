resource "aws_route53_record" "frontend" {
  zone_id = ""
  name    = "frontend.dev.manupanand.online"
  type    = "A"
  ttl     = 25
  records = [var.private_ip]
}
variable "private_ip" {
  
}