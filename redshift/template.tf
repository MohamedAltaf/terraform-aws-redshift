# RedShift Subnets ===============================================================

resource "aws_subnet" "redshift_subnets" {
  count             = "${length(var.availability_zones)}"
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.redshift_subnets[count.index]}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags = "${merge(var.tags, map("Name", "${var.env_name}-redshift-subnet${count.index}"))}"
}

resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name        = "${var.env_name}_redshift_subnet_group"
  description = "RedShift Subnet Group"

  subnet_ids = ["${aws_subnet.redshift_subnets.*.id}"]

  tags = "${merge(var.tags, map("Name", "${var.env_name}-redshift-subnet-group"))}"

  count = "${var.redshift_subnets[count.index] > 0 ? 1 : 0}"
}

# RedShift Security Group ===============================================================

resource "aws_security_group" "redshift_security_group" {
  name        = "redshift_security_group"
  description = "RedShift Security Group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    cidr_blocks = ["${var.vpc_cidr}"]
    protocol    = "tcp"
    from_port   = 5439
    to_port     = 5439
  }

  egress {
    cidr_blocks = ["${var.vpc_cidr}"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = "${merge(var.tags, map("Name", "${var.env_name}-redshift-security-group"))}"

  count = "${var.redshift_subnets[count.index] > 0 ? 1 : 0}"
}

# RedShift CLuster ===============================================================

resource "aws_redshift_cluster" "redshift" {
  cluster_identifier = "${var.cluster_identifier}"
  node_type          = "${var.cluster_node_type}"
  number_of_nodes    = "${var.cluster_number_of_nodes}"
  cluster_type       = "${var.cluster_number_of_nodes > 1 ? "multi-node" : "single-node" }"
  database_name      = "${var.cluster_database_name}"
  master_username    = "${var.cluster_master_username}"
  master_password    = "${var.cluster_master_password}"

  port = "${var.database_port}"

  vpc_security_group_ids = ["${aws_security_group.redshift_security_group.id}"]

  cluster_subnet_group_name    = "${aws_redshift_subnet_group.redshift_subnet_group.*.id}"

  publicly_accessible = "${var.publicly_accessible}"

  # IAM Roles
  iam_roles = "${aws_iam_instance_profile.redshift_role.name}"

  # Encryption
  encrypted  = "${var.encrypted}"
  kms_key_id = "${var.kms_key_id}"

  # Enhanced VPC routing
  enhanced_vpc_routing = "${var.enhanced_vpc_routing}"

  tags = "${var.tags}"

}
