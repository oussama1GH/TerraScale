provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = var.subnet_cidr
}

resource "google_container_cluster" "private_cluster" {
  name       = "my-cluster"
  location   = var.region
  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.subnet.id

  initial_node_count = 1

   # Assure-toi que deletion_protection est défini à false
  deletion_protection = false

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.16/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.0/8"
      display_name = "Private Network"
    }
  }

  ip_allocation_policy {}

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = 60  # Taille du disque de 60 Go pour chaque nœud
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
    ]
 }

  # Spécification des zones pour un cluster multi-zone
  # Si vous avez plusieurs zones, assurez-vous que la variable `zones` est définie correctement

}

resource "google_compute_instance" "bastion_host" {
  name         = "bastion-host"
  machine_type = var.bastion_machine_type
  zone         = var.zone
  tags         = ["bastion"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 60  # Taille du disque du bastion host (en Go)
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }
}
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-to-bastion"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]
}

resource "google_compute_firewall" "allow_bastion_to_cluster" {
  name    = "allow-bastion-to-cluster"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_tags = ["bastion"]
  target_tags = ["private-cluster"]
}
