variable "rest_api_name" {
  description = "API GW name"
  type        = string
}

variable "rest_api_description" {
  description = "API GW description"
  type        = string
}

# variable "resource_path" {
#   description = "API GW resource root path"
#   type        = string
# }


# variable "api_gw_method" {
#   description = "API GW method"
#   type        = string
# }

# variable "lambda_invoke_arn" {
#   description = "Lambda invoke arn for api GW and lambda integration"
#   type        = string
# }

variable "integration_method" {
  description = "Lambda - API GW integration method"
  type        = string
}

variable "type" {
  description = "Lambda - API GW integration method"
  type        = string
}

variable "stage_name" {
  description = "API GW stage name"
  type        = string
}

variable "endpoints_config" {
  type = list(object({
    path   = string
    method = string
    lambda = string
  }))
}