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
    value=var.list[2]
}
variable "name"{
    default = "manu"
}
output "echo"{
    value="username : ${var.name}"
}
variable "map"{
    default = {
        course="Devops",
        trainer="manu"
    }
}
output "map-data"{
    value=" Course : ${var.map["course"]}, trainer is : ${var.map.trainer}"
}
variable "empty"{
    
}
output "empty-variable"{
    value=var.empty
}