output "iaas" {
  value = "aws"
}

output "redshift_cluster_endpoint" {
  description = "The connection endpoint"
  value       = "${module.redshift.redshift_cluster_endpoint}"
}

output "bucket" {
  description = "S3 bucket arn"
  value = "${module.redshift.bucket}"
}
