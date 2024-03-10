
# Allow API GW to execute lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  #function_name = aws_lambda_function.products_lambda.function_name
  function_name = var.lambda_function_name
  principal = "apigateway.amazonaws.com"
  #source_arn = "${aws_api_gateway_rest_api.products_api_tfp.execution_arn}/*"
  source_arn = "${var.api_gw_execution_arn}/*"
}





