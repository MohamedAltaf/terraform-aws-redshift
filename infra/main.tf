resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = "${merge(var.tags, map("Name", "${var.env_name}-vpc"))}"
}

# Private Route Table ===============================================================

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
