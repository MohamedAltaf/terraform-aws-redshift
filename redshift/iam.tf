# RedShift IAM Role ===============================================================

resource "aws_iam_role" "redshift_role" {
  name = "${var.env_name}_redshift-role"

  lifecycle {
    create_before_destroy = true
  }

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": [
          "${redshift_bucket_arn}"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource": [
          "${redshift_bucket_arn}/*"
        ]
      }
    ]
  }
EOF
}

resource "aws_iam_instance_profile" "redshift_role" {
  name = "${var.env_name}_redshift-role"
  role = "${aws_iam_role.redshift_role.name}"

  lifecycle {
    ignore_changes = ["name"]
  }
}
