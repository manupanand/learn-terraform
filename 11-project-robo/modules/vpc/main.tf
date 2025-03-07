resource "aws_vpc" "name" {
  cidr_block = var.cidr
  tags = {
    Name="${var.env}"
  }
}