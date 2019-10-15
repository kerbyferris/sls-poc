resource "aws_dynamodb_table" "basic" {
  name           = "${var.stage}_Basic"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_ssm_parameter" "ssm_dynamodb" {
  type        = "String"
  description = "Name of DynamoDB Table"
  name        = "/${var.app_name}/${var.stage}/dynamodb_table"
  value       = aws_dynamodb_table.basic.name
  overwrite   = true
}

resource "aws_ssm_parameter" "ssm_dynamodb_arn" {
  type        = "String"
  description = "ARN of DynamoDB Table"
  name        = "/${var.app_name}/${var.stage}/dynamodb_table_arn"
  value       = aws_dynamodb_table.basic.arn
  overwrite   = true
}
