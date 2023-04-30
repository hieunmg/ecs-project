## Terraform block
terraform {
  backend "s3" {
    profile = "hieunm"
  }
}

## Provider block
provider "aws" {
  region  = "ap-southeast-1"
  # profile = "hieunm"
}
