resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn  = var.kinesis_stream
  function_name     = var.lambda_function_name
  starting_position = "LATEST"
}
