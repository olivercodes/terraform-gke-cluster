provider "google" {
  project = var.project
  region  = var.region
  credentials = var.GCP_SERVICE_ACCOUNT
}

module "network" {

}

module "gke-cluster" {

}
