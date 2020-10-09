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

resource "google_container_cluster" "my_cluster" {
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
  cluster    = google_container_cluster.my_cluster.name
  node_count = var.kube-nodecount

  node_config {
    preemptible  = var.kube-preemptible
    machine_type = "n1-standard-1"
    disk_size_gb = 10
    disk_type = "pd-standard"


    metadata = {
      disable-legacy-endpoints = "true",
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
data "google_client_config" "provider" {}

provider "kubernetes" {
  load_config_file = false
  host = "https://${google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,)
}


resource "kubernetes_namespace" "example" {
  depends_on = [google_container_node_pool.primary_preemptible_nodes]
  count = length(var.namespaces)
  metadata {
    name  = var.namespaces[count.index]
  }
}

resource "kubernetes_deployment" "example-app" {
  depends_on = [google_container_node_pool.primary_preemptible_nodes]
  metadata {
    name = "terraform-example"
    labels = {
      test = "MyExampleApp"
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        test = "MyExampleApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "MyExampleApp"
        }
      }

      spec {
        container {
          image = "nginx:1.7.8"
          name  = "example"
		  port{
		  container_port = var.nginxport
		  }
          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "example-app" {
  depends_on = [google_container_node_pool.primary_preemptible_nodes]
  metadata {
    name = "terraform-example"
  }
  spec {
    selector = {
      test = "MyExampleApp"
    }
    session_affinity = "ClientIP"
    port {
      port        = var.nginxport
    }

    type = "LoadBalancer"
  }
}



