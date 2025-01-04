provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0abcdef1234567890" # Replace with a valid AMI
  instance_type = "t2.micro"

  tags = {
    Name = "web-server"
  }
}

output "instance_ips" {
  value = aws_instance.web.*.public_ip
}
