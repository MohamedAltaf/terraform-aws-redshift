resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = "${merge(var.tags, map("Name", "${var.env_name}-vpc"))}"
}

resource "aws_security_group" "vms_security_group" {
  name        = "vms_security_group"
  description = "VMs Security Group"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    cidr_blocks = ["${var.vpc_cidr}"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = "${merge(var.tags, map("Name", "${var.env_name}-vms-security-group"))}"
}

# Private Subnet ===============================================================

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(var.tags, map("Name", "${var.env_name}-private_route_table"))}"
}

# S3 Endpoint===============================================================

resource "aws_vpc_endpoint" "s3_endpoint" {
    vpc_id = "${aws_vpc.vpc.id}"
    service_name = "com.amazonaws.${var.region}.s3"
    route_table_ids = ["${aws_route_table.private_route_table.id}"]
    policy = <<POLICY
{
    "Statement": [
        {
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
}
POLICY
}
