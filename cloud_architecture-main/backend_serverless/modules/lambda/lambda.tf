resource "aws_lambda_function" "lambda_function" {
  function_name    = var.function_name
  filename         = var.package_filename
  role             = var.role
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = var.source_code
}





