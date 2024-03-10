variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "package_filename" {
  description = "Lambda zip package"
  type        = string
}

variable "handler" {
  description = "Lambda handler name"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
}

variable "source_code" {
  description = "Lambda source code"
  type        = string
}

variable "role" {
  description = "Role granting lambdas permission to interact with other services"
  type        = string
}

