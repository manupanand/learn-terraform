resource "null_resource" "test" {
    for_each = var.fruits

}
variable "fruits" {
        default = {
            apple={
                name="apple"
                quantity=100
            }
            banana={
                name="banana"
                quantity=30
            }
        }
  
}

resource "null_resource" "instance" {
  
}

variable "instance" {
    default = {
        frontend={}
        catalogue={}
        mongo={}
    }
}