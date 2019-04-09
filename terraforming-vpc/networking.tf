# Private Subnet ===============================================================

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(var.tags, map("Name", "${var.AppName}:net:${var.AppID}:privateRouteTable:${var.env_name}"), map("CitiSystemsInventory", "CsiAppId=${var.AppID}|BillingProfileNumber=${var.BillingID}"), map("CTIResourceAudit", "InstantiatedBy=CFN|StartDateTime=NA|PublicRouted=No"), map("BusinessAudit", "InstalledSoftware=NA|ExpiryDateTime=NA|Environment=${var.env_name}"))}"
}

# VPN Gateway===============================================================

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${aws_vpc.vpc.id}"
  #amazon_side_asn = "${var.amazon_side_asn}"

  tags = "${merge(var.tags, map("Name", "${var.AppName}:net:${var.AppID}:virtualPrivateGW:${var.env_name}"), map("CitiSystemsInventory", "CsiAppId=${var.AppID}|BillingProfileNumber=${var.BillingID}"), map("CTIResourceAudit", "InstantiatedBy=CFN|StartDateTime=NA|PublicRouted=No"), map("BusinessAudit", "InstalledSoftware=NA|ExpiryDateTime=NA|Environment=${var.env_name}"))}"
}

resource "aws_vpn_gateway_route_propagation" "gateway_route_prop" {
  vpn_gateway_id = "${aws_vpn_gateway.vpn_gw.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

# DHCP Options==============================================================

resource "aws_vpc_dhcp_options" "citi_dhcp_template" {
  domain_name          = "aws.nam.nsroot.net"
  domain_name_servers  = "${var.domain_name_servers}"

  tags = "${merge(var.tags, map("Name", "${var.AppName}:net:${var.AppID}:DHCPoptions:${var.env_name}"), map("CitiSystemsInventory", "CsiAppId=${var.AppID}|BillingProfileNumber=${var.BillingID}"), map("CTIResourceAudit", "InstantiatedBy=CFN|StartDateTime=NA|PublicRouted=No"), map("BusinessAudit", "InstalledSoftware=NA|ExpiryDateTime=NA|Environment=${var.env_name}"))}"
}

resource "aws_vpc_dhcp_options_association" "dhcp_template_to_vpc_association" {
  vpc_id          = "${aws_vpc.vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.citi_dhcp_template.id}"
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

# VPC Flow Log Group, Role and Association=================================

resource "aws_iam_role" "vpc_flow_log_role" {
  name = "vpc_flow_log_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name = "vpc_flow_log_policy"
  role = "${aws_iam_role.vpc_flow_log_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name = "vpc_flow_log_role"
  retention_in_days = "7"
}

resource "aws_flow_log" "vpc_flow_log_association" {
  iam_role_arn    = "${aws_iam_role.vpc_flow_log_role.arn}"
  log_destination = "${aws_cloudwatch_log_group.vpc_flow_log_group.arn}"
  traffic_type    = "ALL"
  vpc_id          = "${aws_vpc.vpc.id}"
}
