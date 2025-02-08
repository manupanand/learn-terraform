


variable "domain_name"{
    default = "manupanand.online"
}
variable "components" {
  default = {
    frontend = {
      instance_type = "t3.micro"
    }
    backend = {
        instance_type = "t3.micro"
    }
    mongo = {
        instance_type = "t3.small"
    }
  }
}