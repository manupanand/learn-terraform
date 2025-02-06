resource "aws_instance" "web_local"{
    instance_type="t3.micro"
    ami="ami-0d81f2cd09b410166"
    tags={
        Name="demo-terraform"
    }
}