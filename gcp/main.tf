provider "google" {
  project     = "zeta-flare-449207-r0"
  region      = "asia-south1"
}
resource "google_compute_network" "vpc_network" {
  project                 = "zeta-flare-449207-r0"
  name                    = "vpc-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}