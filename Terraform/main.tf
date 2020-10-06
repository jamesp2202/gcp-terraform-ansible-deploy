provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
  credentials = "google-key.json"
}


terraform {
  backend "gcs" {
    bucket = "tf-state-bucket-devenv"
    prefix = "terraform"
    credentials = "google-key.json"
   }
}

resource "google_container_cluster" "primary" {
  name     = var.kube-clustername
  location = var.zone
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = var.kube-poolname
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.kube-nodecount

  node_config {
    preemptible  = var.kube-preemptible
    machine_type = "n1-standard-1"
    disk_size_gb = 10
    disk_type = "pd-standard"


    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}


