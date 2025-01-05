resource "aws_instance" "frontend" {
  ami           = "ami-0fd05997b4dff7aac"
  instance_type = "t3.micro"
  vpc_security_group_ids=["sg-0a98a718c2de79dee"]

  tags = {
    Name = "frontend.dev"
  }
}

output "private_ip" {
  value = aws_instance.frontend.private_ip
}
