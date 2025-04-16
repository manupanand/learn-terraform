variable "project_id" {}
variable "region" {
  default = "us-central1"
}
variable "credentials_file" {
  default = "~/.gcp/terraform-sa-key.json" # adjust if stored elsewhere
}
