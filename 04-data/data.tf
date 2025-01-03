data "aws_ami" "example"{
    executable_users=["self"]
    most_recent=true
    name_regex="AMI name"
    owners = ["619494949"]#owner number
}
#aws machine images AMI id may change ,use AMI name name_regex
#owner =account number
output "ami"{
    value=data.aws_ami.example #prefix with data -> previously we use resource name
}