resource "aws_instance" "frontend" {
    ami = "ami-0fd05997b4dff7aac"
    instance_type = "t3.micro"
    vpc_security_group_ids = ["sg-0a98a718c2de79dee"]
    tags = {
      Name="frontend.dev"
    }
    provisioner "remote-exec" {
      connection {
        user = "ec2-user"
        password = "password"
        host = self.private_ip# self means those from which it run
      }
      inline = [ 
               "sudo pip-3.11 install ansible",
               "ansible-pull -i localhost, -U https://github.com/username/repo main.yml -e env=dev -e role_name=frontend"# if in loop {each.key}
       ]
    }
  
}