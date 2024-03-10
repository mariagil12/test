resource "aws_kinesis_stream" "stream" {
  name             = var.name
  shard_count      = var.shards
  retention_period = var.retention_period

  tags = {
    Environment = "stream"
  }
}

