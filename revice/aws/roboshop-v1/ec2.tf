resource "aws_instance" "frontend"{
    instance_type="t3.micro"
    ami="ami-0d81f2cd09b410166"
    vpc_security_group_ids = ["sg-00ac6f603cfd19030"]
    tags={
        Name="frontend.dev"
    }
} 