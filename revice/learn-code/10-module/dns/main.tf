resource "aws_route53_record" "frontend" {
  zone_id = "Z02556032JV56RSCGA16T"
  name    = "frontend.dev.manupanand.online"
  type    = "A"
  ttl     = 25
  records = [var.private_ip]
}
#recieve input
variable "private_ip" {
  
}
