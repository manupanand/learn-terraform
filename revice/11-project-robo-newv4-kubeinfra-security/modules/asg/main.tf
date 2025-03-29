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
# # laod balancer security group
# resource "aws_security_group" "load-balancer" {
#   # count = var.asg ? 1: 0 # only need to create when ASG is enabled
#    name = "${var.name}-${var.env}-alb-sg"
#    description = "${var.name}-${var.env}-alb-sg"
#    vpc_id = var.vpc_id
#    egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#    }
#    ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "TCP"
#     cidr_blocks = var.allow_lb_sg_cidr
#    }
#    ingress {
#     from_port = 443
#     to_port =443
#     protocol = "TCP"
#     cidr_blocks = var.allow_lb_sg_cidr
#    }
   
#    tags = {
#      Name="${var.name}-${var.env}-alb-sg"
#    }
# }



# launch template

resource "aws_launch_template" "main" {
  # count = var.asg ? 1: 0 # if asg is present set count to 1
  name= "${var.name}-${var.env}-lt"
  image_id = data.aws_ami.ami-data.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  # spot instance
  instance_market_options {
    market_type = "spot"# no need -spot options for stop  since it is auto scaling group
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 30
    }
  }

  # launch commands
  user_data = base64encode(templatefile("${path.module}/userdata.sh",{
    role_name= var.name
    app_name=var.name
    env=var.env
    vault_token=var.vault_token
  }))
  tags = {
     Name="${var.name}-${var.env}-lt"
   }
}
# auto scaling group
resource "aws_autoscaling_group" "main" {
  # count = var.asg ? 1: 0 # if asg is present set count to 1
  name = "${var.name}-${var.env}-asg"
  desired_capacity = var.capacity["desired"]
  max_size = var.capacity["max"]
  min_size = var.capacity["min"]
  vpc_zone_identifier = var.subnet_ids
  target_group_arns = [aws_lb_target_group.main.arn]
  
  launch_template {
    id=aws_launch_template.main.id
    version = "$Latest"
  }
  tag {
    key = "Name"
    propagate_at_launch = true
    value = "${var.name}-${var.env}-asg"
  }
}

# load balancer

# resource "aws_lb" "main" {
#   # need to create only when auto scaling group is creating
#   #  count = var.asg ? 1: 0
#    name = "${var.name}-${var.env}-lb"
#    internal =  var.internal
#    load_balancer_type = "application"
#    security_groups = [aws_security_group.load-balancer.id]
#    subnets = var.lb_subnet_ids
#    tags = {
#      Environment="${var.name}-${var.env}-lb"
#    }

  
# }

# target group for load balancer
resource "aws_lb_target_group" "main" {
  # count = var.asg ? 1: 0
  #port for group is 8080
  name =  "${var.name}-${var.env}-lb-tg"
  port = var.allow_port
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    enabled = true
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 5
    path="/health"
    timeout=3
  }
}# give target group arn to autoscaling group

# load balancer listener rule
# resource "aws_lb_listener" "internal-http" {
#   count = var.internal ? 1: 0
#   load_balancer_arn = aws_lb.main.arn
#   port = "80"
#   protocol = "HTTP"
#   default_action {
#     type =  "forward"
#     target_group_arn = aws_lb_target_group.main.arn
#   }
# }


# frontend has load balancer on public side/public subnet

# dns record
resource "aws_route53_record" "loadbalancer" {
  #  count = var.asg ? 1: 0
   zone_id = var.zone_id
   name= "${var.name}.${var.env}"
   type = "CNAME"
   ttl= 10
   records = [var.dns_name]# there is a default dns created by aws, we riute it to another ourown wi
}# HERE from potupt of load balancer dns is used outputs.td from loadbalcer

# each and every component will have listner rule
resource "aws_lb_listener_rule" "listener-rule" {
  listener_arn  = var.listener_arn
  priority      = var.lb_rule_priority

  action{
      type = "forward"
      target_group_arn = aws_lb_target_group.main.arn
  }
  condition{
    host_header {
      values = [aws_route53_record.loadbalancer.fqdn]#fully qualified domain name
    }
  }
}