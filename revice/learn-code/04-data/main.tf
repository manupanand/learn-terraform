data "aws_ami" "ami-data"{
    most_recent = true
    name_regex = ""
    owners = [""]
}

output "am"{
    value=data.aws_ami.ami-data
  }