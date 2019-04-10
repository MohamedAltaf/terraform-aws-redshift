
variable "env_name" {
  type = "string"
}

variable "availability_zones" {
  type = "list"
}

variable "vpc_cidr" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "cluster_identifier" {
  description = "Custom name of the cluster"
}

variable "cluster_node_type" {
  description = "Node Type of Redshift cluster"
}

variable "cluster_number_of_nodes" {
  description = "Number of nodes in the cluster (values greater than 1 will trigger 'cluster_type' of 'multi-node')"
  default     = 2
}

variable "cluster_database_name" {
  description = "The name of the database to create"
}

variable "cluster_master_username" {}

variable "cluster_master_password" {}

variable "database_port" {
  default = 5439
}

variable "publicly_accessible" {
  description = "Determines if Cluster can be publicly available (NOT recommended)"
  default     = false
}

variable "redshift_subnets" {
  type        = "list"
  description = "A list of redshift subnets"
  default     = []
}

variable "encrypted" {
  description = "(Optional) If true , the data in the cluster is encrypted at rest."
  default     = false
}

variable "kms_key_id" {
  description = "(Optional) The ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true."
  default     = ""
}

variable "enhanced_vpc_routing" {
  description = "(Optional) If true, enhanced VPC routing is enabled."
  default     = false
}

variable "tags" {
  type = "map"
}
