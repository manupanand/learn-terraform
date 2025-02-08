resource "null_resource" "test"{
    count =3
}
variable "components" {
    default = ["frontend","datatbase","backend"]
}
resource "null_resource" "test1"{
    count =lenght(var.components)
}
  
