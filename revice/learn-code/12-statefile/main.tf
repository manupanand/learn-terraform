resource "null_resource" "name" {
  
}

terraform {
  backend "s3" {
    bucket = "dev-ops-state-manupa"
    key    = "test/terraform.tfstate"
    region = "ap-south-1"
  }
}
# run terraform init