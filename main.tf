variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project}-${var.cluster_type}-gke"
  location = var.region

  # B/c of how gke creates clusters, it will still create the default pool. If you monitor the deployment, you will see it create 3 default nodes,
  # verify them, and then destroy them. GKE will then proceed to create the independant node pool (see node_pool resource below)
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.vpc_name
  subnetwork = var.subnet_name

}

# Separately Managed Node Pool
resource "google_container_node_pool" "node_pools" {
  
  # Here, we are going iterate over the set of node_pools, and create each one
  for_each   = var.node_pools

  name       = "${google_container_cluster.primary.name}-${each.key}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = each.value.node_count

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project
    }

    # preemptible  = true
    machine_type = each.value.machine_type
    tags         = ["gke-node", "${var.project}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

