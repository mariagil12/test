resource "aws_dynamodb_table" "inventory-table" {
  name           = var.name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.hash_key

  attribute {
    name = "productId"
    type = "N"
  }
  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}