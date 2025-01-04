variable "instace_type" {
  default = "t3.small"
}
variable "domain_name" {
  default = "example.online"
}
variable "components" {
  default = ["frontend","catalogue","mongo"]
}