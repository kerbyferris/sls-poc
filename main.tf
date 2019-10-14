provider "aws" {
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "tf-state-575575708653"
    key    = "terraform.slsPoc.tfstate"
    region = "us-east-1"

  }
}

resource "aws_dynamodb_table" "basic" {
  name           = "Basic"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_ssm_parameter" "ssm_dynamodb" {
  type        = "String"
  description = "Name of DynamoDB Table"
  name        = "/first/dev/dynamodb_table"
  value       = aws_dynamodb_table.basic.name
  overwrite   = true
}

resource "aws_ssm_parameter" "ssm_dynamodb_arn" {
  type        = "String"
  description = "ARN of DynamoDB Table"
  name        = "/first/dev/dynamodb_table_arn"
  value       = aws_dynamodb_table.basic.arn
  overwrite   = true
}

resource "aws_iam_user_policy" "circleci" {
  name = "SLS_POC_CircleCi_Policy"
  user = "circleci"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "dynamodb:*",
                "iam:*",
                "lambda:*",
                "s3:*",
                "logs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}
