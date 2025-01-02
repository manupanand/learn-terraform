

resource "aws_instance" "web" {
  ami           = "ami-0fd05997b4dff7aac"
  instance_type = "t3.micro"

  tags = {
    Name = "test-terraform"
  }
}