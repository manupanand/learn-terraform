resource "null_resource" "test" {
  
}
#can be any resource-> send to s3

terraform {
  backend "s3" {
    bucket = "bucket-name"
    key = "test/terraform.tfstate"
    region = "ap-south-1"
  }
}