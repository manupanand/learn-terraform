variable "instance_type"{
    default = "t3.micro"
}
variable "ami"{
    default = "ami-0d81f2cd09b410166"
}
variable "security_group_id"{
    default =  "sg-00ac6f603cfd19030"
}

variable "zone_id"{
    default = ""
}
variable "domain_name"{
    default = "manupanand.online"
}