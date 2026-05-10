terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Firewall rule: allow inbound traffic on port 3000 (Juice Shop) and 22 (SSH)
resource "google_compute_firewall" "juiceshop" {
  name    = "allow-juiceshop"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3000", "22"]
  }

  # Restrict SSH to your own IP in production — for now open to all
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["juiceshop"]
}

# e2-micro is in GCP's always-free tier (us-central1, us-west1, us-east1)
resource "google_compute_instance" "juiceshop" {
  name         = "juiceshop"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["juiceshop"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10 # GB — plenty for the OS + Docker image
    }
  }

  network_interface {
    network = "default"

    # Ephemeral (dynamic) public IP — no extra cost
    access_config {}
  }

  # Startup script: installs Docker and runs Juice Shop on boot
  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e

    # Install Docker
    apt-get update -y
    apt-get install -y docker.io
    systemctl enable docker
    systemctl start docker

    # Pull and run OWASP Juice Shop
    # --restart unless-stopped ensures it comes back up if the instance reboots
    docker run -d \
      --name juiceshop \
      --restart unless-stopped \
      -p 3000:3000 \
      bkimminich/juice-shop
  EOF
}
