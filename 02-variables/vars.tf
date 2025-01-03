#plain variable -number
variable "x" {
    default= 100
}
#boolean
variable "y"{
    default=true
}
#string
variable "z"{
    default="manu"
}
# values numbers and boolean are not used in quotes
#list variable
variable "list"{
    default=[10,20,"abc",false]
}
# variable map
variable "map"{
    default={
        course="Devops",
        trainer="manu"
    }
}
#direct values doesnot require to be accesedd with ${}
output "x" {
    value=var.x
}
#accesing varibale has a compination with string we need to use ${}
output "x1" {
    value= "Value of x-${var.x}"
}
# single quotes is note supported by terraform
output "list"{
    value=var.list[0]
}
#map output
output "map"{
    value=" Course is :${var.map["course"]} trainer is ${var.map["trainer"]}"
}

variable "c"{}# empty how terraform will respond
#will prompt for input variable
#how to enter variable from commad bash
 #along terraform apply -var c=100 -> comes in c="100" later  convert

variable "e"{
    type=number
}
 output "c"{
    value=var.c
 }
  output "e"{
    value=var.e
 }
 # not a scalable approch send var in commndline
 # use a file for variables
 #teraform->terraform.tfvars
 # if use demo.tfvars -> -var-file=demo.tfvars