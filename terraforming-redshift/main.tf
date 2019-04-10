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
    Application = "Cloud Foundry"
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

  cluster_identifier      = "${module.redshift.redshift_cluster_identifier}"
  cluster_node_type       = "${module.redshift.redshift_cluster_node_type}"
  cluster_number_of_nodes = "${module.redshift.redshift_cluster_number_of_nodes}"

  cluster_database_name   = "${module.redshift.redshift_cluster_database_name}"
  cluster_master_username = "${var.cluster_master_username}"
  cluster_master_password = "${var.cluster_master_password}"

  availability_zones      = "${var.availability_zones}"
  env_name                = "${var.env_name}"
  vpc_cidr                = "${var.vpc_cidr}"
  vpc_id                  = "${module.infra.vpc_id}"
  redshift_subnets        = ["${module.redshift.redshift_subnets}"]
  vpc_security_group_ids  = ["${module.redshift.vpc_security_group_ids}"]

  tags                    = "${local.actual_tags}"

}
