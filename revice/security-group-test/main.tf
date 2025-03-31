provider "aws" {
  region = "ap-south-2"
}
terraform {
  backend "s3" {
    bucket = "devops-state-manupanand-aps2"
    key    = "test3/dev/terraform.tfstate"
    region = "ap-south-2"
  }
}
resource "aws_security_group" "kube_control_plane" {
    description = "Security group for control plane"
    name        = "control-plane-sg"
    vpc_id      =   data.aws_vpc.private_vpc.id 
  

#ssh port
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "TCP"
        cidr_blocks  =["0.0.0.0/0"] #cidr of default vpc
    }

# kube main ports
  dynamic "ingress" {
    for_each = var.cp_ingress
    content {
      from_port     = tonumber(split("-",ingress.value.port)[0])
      to_port       = tonumber(split("-",ingress.value.port)[length(split("-",ingress.value.port))-1])
      protocol      = "TCP"
      cidr_blocks   = [tostring(data.aws_subnet.kube_subnet.cidr_block) ]#var.kube_subnet_cidr data.aws_subnet.kube_subnet.cidr_block
    }
  }
# dynamic egress
    # dynamic "egress" {
    # for_each = var.cp_egress
    # content {
    #     from_port     = tonumber(split("-",ingress.value.port)[0])
    #     to_port       = tonumber(split("-",ingress.value.port)[length(split("-",ingress.value.port))-1])
    #     protocol    = "TCP"
    #     cidr_blocks = [tostring(data.aws_subnet.kube_subnet.cidr_block)] 
    # }
    # }
    # egress {
    #   from_port   = 0
    #   to_port     = 0
    #   protocol    = "-1"
    #   cidr_blocks = ["0.0.0.0/0"]
    # }


    tags={
        Name="control-plane-sg"
    }
}