provider "aws" {
  region = "ap-south-2"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}