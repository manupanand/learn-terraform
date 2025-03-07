resource "aws_security_group" "main" {
   name = "${var.name}-${var.env}-sg"
   description = "Allow tls inbound traffic and all outbound traffic"
   vpc_id = var.vpc_id
   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
   }
   ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = var.bastion_nodes
   }
   ingress {
    from_port = var.allow_port
    to_port = var.allow_port
    protocol = "TCP"
    cidr_blocks = var.allow_sg_cidr
   }
   tags = {
     Name="${var.name}-${var.env}-sg"
   }
}


# ec2 instance


# when asg -> false->0 above will not run, but db need to be created
resource "aws_instance" "main" {
  # count = var.asg ? 0: 1 # it should not run when asg is true, that mean other instances
  ami = data.aws_ami.ami-data.image_id
  instance_type = var.instance_type
  subnet_id = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.main.id]

  # launch commands
  user_data = base64encode(templatefile("${path.module}/userdata.sh",{
    role_name= var.name
    env=var.env
    vault_token=var.vault_token
  }))
  tags = {
    Name= "${var.name}-${var.env}-db"
  }
}

# dns record
resource "aws_route53_record" "instance" {
  #  count = var.asg ? 0: 1
   zone_id = var.zone_id
   name= "${var.name}.${var.env}"
   type = "A"
   ttl= 10
   records = [aws_instance.main.private_ip]
}

