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
variable "fruits" {
  default = {
    apple={
        name="apple"
        quantity=100
    }
    banana={
        name="banana"
        quantity=20
    }
  }
}
resource "null_resource" "fruits" {
  for_each = var.fruits
}

variable "instances" {
  default = {
    frontend={}
    catalogue={}
    mongo={}
  }
}
resource "null_resource" "instaces" {
  for_each = var.instances
}