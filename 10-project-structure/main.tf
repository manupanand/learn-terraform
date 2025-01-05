terraform {
  backend "s3" {
    #rest of things come from env state
  }
}
resource "null_resource" "test" {
  
}