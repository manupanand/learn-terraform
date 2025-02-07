variable "x"{
    default=10
}
output "x"{
    value= var.x
}
variable "y"{
    default=true
}
output "y" {
    value=var.y
}
variable "list"{
    default=[10,20,"name",true]
}
output "list"{
    value=list[2]
}