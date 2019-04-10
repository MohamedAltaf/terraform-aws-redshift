# What is this?

Set of terraform modules for creating vpc and deploying redshift cluster with IAM role that allows read/write access to the bucket. Below resources have been used.

- A Virtual Private Network (VPC), Virtual Private Gateway, S3PrivateEndPoint, Subnets, Security Groups
- Necessary s3 buckets
- RedShift Cluster
- An IAM User with proper permissions
- Tagged resources

Note: This is not an exhaustive list of resources created, this will vary depending of your arguments and what you're deploying.

## Prerequisites

```bash
brew update
brew install terraform
```
## Deploying RedShift Cluster

Perform the following steps:

0. `cd` into the proper directory:
  - [redshift](terraforming-redshift/)

0. Create [`terraform.tfvars`](/README.md#var-file) file
0. Run terraform apply.
  ```bash
  terraform init
  terraform plan -out=plan
  terraform apply plan
  ```

### Var File

Copy the stub content below into a file called `terraform.tfvars` and put it in the root of this project.
These vars will be used when you run `terraform apply`.
You should fill in the stub values with the correct content.

```hcl
env_name           = "some-environment-name"
access_key         = "access-key-id"
secret_key         = "secret-access-key"
region             = "us-east-1"
availability_zones = ["us-east-1a"]
vpc_cidr           = "10.0.0.0/16"
redshift_subnets   = ["10.0.1.0/24"]
cluster_master_username = "username"
cluster_master_password = "password"

```

### Variables

- env_name: **(required)** An arbitrary unique name for namespacing resources
- access_key **(required)** Your Amazon access_key, used for deployment
- secret_key: **(required)** Your Amazon secret_key, also used for deployment
- region: **(required)** Region you want to deploy your resources to
- availability_zones: **(required)** List of AZs you want to deploy to
- vpc_cidr: **(required)** Internal CIDR block for the AWS VPC.
- redshift_subnets: **(required)** Subnets to deploy redshift cluster.
- cluster_master_username: **(required)** username for redshift cluster.
- cluster_master_password: **(required)** password for redshift cluster.

## Notes



## Tearing down environment

```bash
terraform destroy
```
