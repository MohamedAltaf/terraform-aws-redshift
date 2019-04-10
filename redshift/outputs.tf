output "redshift_cluster_identifier" {
  description = "The Redshift cluster identifier"
  value       = "${aws_redshift_cluster.redshift.cluster_identifier}"
}

output "redshift_cluster_type" {
  description = "The Redshift cluster type"
  value       = "${aws_redshift_cluster.redshift.cluster_type}"
}

output "redshift_cluster_node_type" {
  description = "The type of nodes in the cluster"
  value       = "${aws_redshift_cluster.redshift.node_type}"
}

output "redshift_cluster_number_of_nodes" {
  description = "The Redshift number of nodes"
  value       = "${aws_redshift_cluster.redshift.number_of_nodes}"
}

output "redshift_cluster_database_name" {
  description = "The name of the default database in the Cluster"
  value       = "${aws_redshift_cluster.redshift.database_name}"
}

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
