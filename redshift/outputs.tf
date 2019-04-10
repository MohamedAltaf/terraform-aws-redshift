output "redshift_redshift_cluster_endpoint" {
  description = "The connection endpoint"
  value       = "${aws_redshift_cluster.redshift.endpoint}"
}

output "bucket" {
  value = "${element(concat(aws_s3_bucket.redshift_bucket.*.bucket, list("")), 0)}"
}
