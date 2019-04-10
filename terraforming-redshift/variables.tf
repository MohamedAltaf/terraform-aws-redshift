variable "env_name" {}

variable "access_key" {}

variable "secret_key" {}

variable "region" {}

variable "availability_zones" {
  type = "list"
}

variable "vpc_cidr" {
  type    = "string"
  default = ""
}

variable "redshift_subnets" {
  type        = "list"
  description = "A list of redshift subnets"
  default     = []
}

variable "cluster_identifier" {
  description = "Custom name of the cluster"
  default     = "redshift-cluster"
}

variable "cluster_node_type" {
  description = "Node Type of Redshift cluster"
  default     = "dc1.large"
}

variable "cluster_number_of_nodes" {
  description = "Number of nodes in the cluster (values greater than 1 will trigger 'cluster_type' of 'multi-node')"
  default     = 2
}

variable "cluster_database_name" {
  description = "The name of the database to create"
  default     = "dev"
}

variable "cluster_master_username" {}

variable "cluster_master_password" {}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Key/value tags to assign to all AWS resources"
}
