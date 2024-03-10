variable "name" {
  description = "Dynamo DB name"
  type        = string
}

variable "read_capacity" {
  description = "Read units per second"
  type        = number
}

variable "write_capacity" {
  description = "Write units per second"
  type        = number
}

variable "hash_key" {
  description = "Product unique identifier"
  type        = string
}

