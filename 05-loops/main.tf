#some null resource nothing it do ,testing purpose 
resource "null_resource" "test" {
  count=3# to loop 3 times
}
#to perform activity inputs  and functions->terrafrom functions
variable "components" {
  default = ["frontend","catalogue","mongo"]
}
resource "null_resource" "test2" {
  count = length(var.components)
}