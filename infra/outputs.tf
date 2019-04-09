output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "private_route_table_id" {
  value = "${aws_route_table.private_route_table.id}"
}

output "s3_private_endpoint_id" {
  value = "${aws_vpc_endpoint.s3_endpoint.id}"
}

output "vms_security_group_id" {
  value = "${aws_security_group.vms_security_group.id}"
}
