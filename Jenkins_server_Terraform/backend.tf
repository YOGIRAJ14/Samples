terraform {
  backend "s3" {
    bucket = "young-minds-app"        # S3 bucket name to store the tfstate file
    region = "us-east-1"              # AWS region where the bucket exists
    key = "eks/terraform.tfstate"     # Path (key) within the bucket
  }
}
