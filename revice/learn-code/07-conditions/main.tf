
resource "aws_route53_record" "frontend" {
  zone_id = "sdfsfdn34232"
  name = "test.example.online"
  type = A
  ttl =var.ttl==""? 15:var.ttl
  records = ["1.1.1.1"]
}
variable "ttl" {
  
}