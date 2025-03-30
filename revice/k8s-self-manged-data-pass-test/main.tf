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
resource "aws_instance" "node_1" {
     ami                         = var.aws_ami_id
     instance_type               = "t3.micro"
     vpc_security_group_ids      = [var.security_group_id]
     key_name                    =  "workstation-server" 

     user_data = base64encode(templatefile("${path.module}/node-1.sh",{
        AWS_USER     =var.aws_user
        AWS_PASSWORD =var.aws_password
        role_name    ="node-1"
     }))
  #check file
    provisioner "remote-exec" {
      inline = [ "while [ ! -e /tmp/execute.sh ]; do sleep 60 ; done" ]
    }
    connection {
      type     = "ssh" 
      user     = var.aws_user
      password = var.aws_password
      host     = self.public_ip 
    }
 
}
output "node_1_ip" {
    depends_on = [ aws_instance.node_1 ]
  value =  aws_instance.node_1.public_ip
}
resource "time_sleep" "delay" {
  depends_on = [ aws_instance.node_1 ]
  create_duration = "180s"
}
resource "null_resource" "wait" {
    depends_on = [ time_sleep.delay ]
  provisioner "local-exec" {

    command = <<EOT
        while [ -z "$(terraform output -raw node_1_ip)" ]; do
          echo "waiting for node1 public ip"
          sleep 10
        done

    EOT
    
  }
  
}


resource "aws_instance" "node_2" {
  depends_on = [ null_resource.wait ]
    ami                         = var.aws_ami_id
     instance_type               = "t3.micro"
     vpc_security_group_ids      = [var.security_group_id]
    key_name                    =  "workstation-server" 

     user_data = base64encode(templatefile("${path.module}/node-2.sh",{
        AWS_USER     =var.aws_user
        AWS_PASSWORD =var.aws_password
        role_name    ="node-2"
        remote_ip    = aws_instance.node_1.public_ip
     }))
      #check file- self check scp
    provisioner "remote-exec" {
      inline = [ "while [ ! -e /tmp/execute.sh ]; do sleep 60 ; done" ]
    }
    connection {
      type     = "ssh" 
      user     = var.aws_user
      password = var.aws_password
      host     = self.public_ip 
    }
}
variable "aws_user" {
  default = "ec2-user"
}
variable "aws_password" {
  
}
variable "aws_ami_id" {
  default = "ami-0e86c549c4c958e98"
}
variable "security_group_id" {
  default = "sg-00ac6f603cfd19030"
}
