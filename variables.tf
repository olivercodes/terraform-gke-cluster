variable "project" {
  description = "The google cloud project id"
  default = "leagueroster"
}

variable "region" {
  description = "The google cloud infrastructure region"
  default = "us-central1"
}

variable "vpc_name" {
  description = "The vpc name from the network module"
}

variable "subnet_name" {
  description = "The subnet name from the network module"
}

variable "cluster_type" {
  description = "tidb, app, tikv, etc"
  default = "app"
}

variable "node_pools" {
  type = map(object({
    node_count                     = number
    machine_type                   = string
  }))
}
