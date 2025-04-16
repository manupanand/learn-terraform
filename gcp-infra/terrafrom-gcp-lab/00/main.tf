provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_file)
}

# Dummy resource to test auth
resource "google_compute_network" "default" {
  name                    = "terraform-network"
  auto_create_subnetworks = true
}
