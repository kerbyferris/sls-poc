terraform {
  backend "s3" {
    bucket = "tf-state-575575708653"
    key    = "terraform.slsPoc.tfstate"
    region = "us-east-1"
  }
}

locals {
  stage    = terraform.workspace
  app_name = "first"
  region   = "us-east-1"

  context = {
    dev = {
      dynamo_read_capacity  = 1
      dynamo_write_capacity = 1
    }
    prod = {
      dynamo_read_capacity  = 1
      dynamo_write_capacity = 1
    }
  }
}

provider "aws" {
  region = local.region
}

module "dynamo" {
  source         = "./modules/dynamo"
  stage          = local.stage
  app_name       = local.app_name
  read_capacity  = lookup(local.context[local.stage], "dynamo_read_capacity")
  write_capacity = lookup(local.context[local.stage], "dynamo_write_capacity")
}
