resource "aws_route53_record" "name" {
  zone_id = "some id"
  name = "example.com"
  type = "A"
  ttl = 15
  records = [var.private_ip]
}

variable "private_ip" {
  
}