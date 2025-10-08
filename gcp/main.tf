provider "google" {
  project     = ""
  region      = "asia-south1"
}
resource "google_compute_network" "vpc_network" {
  project                 = ""
  name                    = "vpc-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}