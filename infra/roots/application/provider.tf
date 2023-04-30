terraform {
  backend "s3" {
    profile = "hieunm"
  }
}

provider "aws" {
  profile = "hieunm"
  region = "ap-southeast-1"
}