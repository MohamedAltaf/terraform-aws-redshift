output "redshift_subnets" {
  description = "List of IDs of redshift subnets"
  value       = ["${aws_subnet.redshift_subnets.*.id}"]
}

output "redshift_security_group_id" {
  description = "ID of the RedShift Security Group"
  value       = "${aws_security_group.redshift_security_group.*.id}"
}

output "redshift_cluster_endpoint" {
  description = "The connection endpoint"
  value       = "${aws_redshift_cluster.redshift.endpoint}"
}

output "bucket" {
  description = "S3 bucket arn"
  value = "${element(concat(aws_s3_bucket.redshift_bucket.*.bucket, list("")), 0)}"
}
