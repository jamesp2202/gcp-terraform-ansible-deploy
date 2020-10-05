variable "project" {
  default = "plenary-magpie-277617"
}

variable "region" {
  default = "us-central1"
}

variable "zone"  {
  default = "us-central1-c"
}

variable "kube.nodecount" {
	default = "3"
}

variable "kube.clustername" {
	default = "test-cluster"
}

variable "kube.poolname" {
	default = "main-pool"
}

## Are the nodes pre-emptible? (90% savings, lasts up to 24hours)
variable "kube.preemptible" {
	default = "true"
}