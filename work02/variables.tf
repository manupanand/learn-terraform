# variable "instace_type" {
#   default = "t3.small"
# }
variable "domain_name" {
  default = "example.online"
}
variable "components" {
  default = {
    frontend={
      instace_type="t3.micro"
    }
    catalogue={
      instace_type="t3.micro"
    }
    mongo={
      instace_type="t3.small"
    }
  }
}