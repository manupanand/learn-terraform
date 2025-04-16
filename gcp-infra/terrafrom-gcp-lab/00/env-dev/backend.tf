terraform {
  backend "gcs" {
    bucket  = "manupanand-terraform-gcp-lab-state"
    prefix  = "env-dev/state"
  }
}
