# RedShift S3 bucket ===============================================================

resource "aws_s3_bucket" "redshift_bucket" {
  bucket = "${var.env_name}-redshift-bucket"
  acl    = "private"

  tags = "${merge(var.tags, map("Name", "RedShift S3 Bucket"))}"
  }
}
