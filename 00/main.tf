resource "aws_instance" "frontend" {
    ami = "ami-0fd05997b4dff7aac"
    instance_type = "t3.micro"
    vpc_security_group_ids = ["sg-0a98a718c2de79dee"]
    tags = {
      Name="frontend.dev"
    }
  
}
resource "aws_route53_record" "frontend" {
    zone_id = "zonedid"
    name = "frontend.dev"
    type
  
}