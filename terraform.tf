terraform {
  backend "s3" {
    encrypt = true
    bucket  = "givelify"
    key     = "givelify.tfstate"
    region  = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

