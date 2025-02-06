resource "google_compute_instance" "web_local" {
  name         = "demo-terraform"
  machine_type = "e2-micro"
  zone         = "asia-south1-a" # change to your desired zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"  # or any other public image
    }
  }

  network_interface {
    network       = "default"  # or specify a custom network
    access_config {}  # This is required to assign an external IP address
  }

  metadata = {
    # Optional: add startup scripts or additional metadata here
  }

  tags = ["demo-terraform"]  # These tags can be used for firewall rules
}

provider "google" {
  project = "zeta-"
  region  = "asia-south1"
}