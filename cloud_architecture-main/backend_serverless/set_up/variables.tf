# variable "lambda_function_name" {
#   description = "Lambda function name"
#   type        = string
# }
#
# variable "api_gw_execution_arn" {
#   description = "API GA execution arn"
#   type        = string
# }

variable endpoints_config {}


variable "lambda_functions" {
 type        = list(string)
 description = "Lambda Functions"
 default     = ["email", "orders", "products", "shipping"]
}