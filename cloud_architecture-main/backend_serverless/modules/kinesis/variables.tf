variable "name" {
  description = "Kinesis stream name"
  type        = string
}

variable "shards" {
  description = "Kinesis concurrency"
  type        = number
}

variable "retention_period" {
  description = "Kinesis data retention period"
  type        = number
}