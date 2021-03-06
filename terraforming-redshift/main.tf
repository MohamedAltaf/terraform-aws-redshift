provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

terraform {
  required_version = "< 0.12.0"
}

locals {

  default_tags = {
    Environment = "${var.env_name}"
    Application = "RedShift Cluster"
  }

  actual_tags = "${merge(var.tags, local.default_tags)}"
}

module "infra" {
  source              = "../infra"

  region              = "${var.region}"
  env_name            = "${var.env_name}"
  availability_zones  = "${var.availability_zones}"
  vpc_cidr            = "${var.vpc_cidr}"

  tags                = "${local.actual_tags}"
}

module "redshift" {
  source                  = "../redshift"

  cluster_identifier      = "${var.cluster_identifier}"
  cluster_node_type       = "${var.cluster_node_type}"
  cluster_number_of_nodes = "${var.cluster_number_of_nodes}"

  cluster_database_name   = "${var.cluster_database_name}"
  cluster_master_username = "${var.cluster_master_username}"
  cluster_master_password = "${var.cluster_master_password}"

  availability_zones      = "${var.availability_zones}"
  env_name                = "${var.env_name}"
  vpc_cidr                = "${var.vpc_cidr}"
  vpc_id                  = "${module.infra.vpc_id}"
  redshift_subnets        = ["${var.redshift_subnets}"]

  tags                    = "${local.actual_tags}"

}
