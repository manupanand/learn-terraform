resource "aws_instance" "web_local"{
    instance_type="t3.micro"
    ami="ami-0d81f2cd09b410166"
    vpc_security_group_ids = ["sg-00ac6f603cfd19030"]

    # Pass a shell script as user_data to set the password
  user_data = <<-EOF
              #!/bin/bash
              # Set the password for the user "ec2-user" or any user you have
              echo "ec2-user:password@TEST123" | chpasswd
              # Optionally enable password authentication if it's disabled by default
              sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              systemctl restart sshd
              EOF


    tags={
        Name="demo-terraform"
    }
}
# resource "aws_route53_record" "frontend" {
#   zone_id = ""
#   name    = "frontend.dev.manupanand.online"
#   type    = "A"
#   ttl     = 25
#   records = [aws_instance.web_local.private_ip]
# }

output "instance_private_ip" {
  value=aws_instance.web_local.private_ip
}