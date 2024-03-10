resource "aws_api_gateway_rest_api" "inventory_api" {
  name = var.rest_api_name
  description = var.rest_api_description

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "root_resource" {
  for_each = { for each in var.endpoints_config : each.path => each }

  rest_api_id = aws_api_gateway_rest_api.inventory_api.id
  parent_id = aws_api_gateway_rest_api.inventory_api.root_resource_id
  path_part = each.value.path
}

#OPTIONS is meant to be a mock endpoint for enabling CORS

# OPTIONS HTTP method.
resource "aws_api_gateway_method" "options_method" {
  for_each = { for each in var.endpoints_config : each.path => each }
  rest_api_id      = aws_api_gateway_rest_api.inventory_api.id
  resource_id      = aws_api_gateway_resource.root_resource[each.key].id
  http_method      = "OPTIONS"
  authorization    = "NONE"
}

# OPTIONS method response.
resource "aws_api_gateway_method_response" "options_200" {
  for_each = { for each in var.endpoints_config : each.path => each }
  rest_api_id = aws_api_gateway_rest_api.inventory_api.id
  resource_id = aws_api_gateway_resource.root_resource[each.key].id
  http_method = aws_api_gateway_method.options_method[each.key].http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.options_method]

}

# OPTIONS integration.
resource "aws_api_gateway_integration" "options_integration" {
  for_each = { for each in var.endpoints_config : each.path => each }
  rest_api_id          = aws_api_gateway_rest_api.inventory_api.id
  resource_id          = aws_api_gateway_resource.root_resource[each.key].id
  http_method          = "${aws_api_gateway_method.options_method[each.key].http_method}"
  type                 = "MOCK"
  depends_on           = [aws_api_gateway_method.options_method]
}

# OPTIONS integration response.
resource "aws_api_gateway_integration_response" "options_integration_response" {
  for_each    = { for each in var.endpoints_config : each.path => each }
  rest_api_id = aws_api_gateway_rest_api.inventory_api.id
  resource_id = aws_api_gateway_resource.root_resource[each.key].id
  http_method = aws_api_gateway_integration.options_integration[each.key].http_method
  status_code = "${aws_api_gateway_method_response.options_200[each.key].status_code}"
  response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
  depends_on = [aws_api_gateway_method_response.options_200]
}


# Actual endpoint
resource "aws_api_gateway_method" "api_gateway_method" {
  for_each = { for each in var.endpoints_config : each.path => each }

  rest_api_id = aws_api_gateway_rest_api.inventory_api.id
  resource_id = aws_api_gateway_resource.root_resource[each.key].id
  http_method = each.value.method
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "api_gateway_method_response" {
  for_each = { for each in var.endpoints_config : each.path => each }

  rest_api_id = aws_api_gateway_rest_api.inventory_api.id
  resource_id = aws_api_gateway_resource.root_resource[each.key].id
  http_method = aws_api_gateway_method.api_gateway_method[each.key].http_method
  status_code = "200"
    //cors section
  response_parameters = {
        "method.response.header.Access-Control-Allow-Origin" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Headers" = true
    }

  depends_on = [aws_api_gateway_method.api_gateway_method]
}

resource "aws_api_gateway_integration" "lambda_integration" {
  for_each = { for each in var.endpoints_config : each.path => each }

  rest_api_id = aws_api_gateway_rest_api.inventory_api.id
  resource_id = aws_api_gateway_resource.root_resource[each.key].id
  http_method = aws_api_gateway_method.api_gateway_method[each.key].http_method
  integration_http_method = var.integration_method
  type = var.type
  #uri = aws_lambda_function.products_lambda.invoke_arn
  uri = each.value.lambda
#  depends_on    = ["aws_api_gateway_method.api_gateway_method", "aws_lambda_function.lambda"]
  depends_on    = ["aws_api_gateway_method.api_gateway_method"]
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.inventory_api.id
  stage_name = var.stage_name
  depends_on = [aws_api_gateway_integration.lambda_integration]
}


resource "aws_api_gateway_integration_response" "api_gateway_integration_response" {
  for_each = { for each in var.endpoints_config : each.path => each }

  rest_api_id = aws_api_gateway_rest_api.inventory_api.id
  resource_id = aws_api_gateway_resource.root_resource[each.key].id
  http_method = aws_api_gateway_method.api_gateway_method[each.key].http_method
  status_code = aws_api_gateway_method_response.api_gateway_method_response[each.key].status_code

  //cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }


  depends_on = [
    aws_api_gateway_method.api_gateway_method,
    aws_api_gateway_integration.lambda_integration
  ]
}

