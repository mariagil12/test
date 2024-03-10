################################################ API GATEWAY ###############################################
module "api_gateway" {
  source                     = "../modules/api-gateway"
  rest_api_name              = "inventory"
  rest_api_description       = "Manage Inventory"
  integration_method         = "POST"
  endpoints_config           = var.endpoints_config
  type                       = "AWS_PROXY"
  stage_name                 = "PROD"
  depends_on                 = [module.lambda_function]
}

########################################## LAMBDAS #####################################
data "archive_file" "lambda_package" {
  count       = length(var.lambda_functions)
  type        = "zip"
  source_file = "../input/${element(var.lambda_functions, count.index)}.js"
  output_path = "../input/${element(var.lambda_functions, count.index)}.zip"
}

module "lambda_function" {
  count                      = length(var.lambda_functions)
  source                     = "../modules/lambda"
  function_name              = "manage_${element(var.lambda_functions, count.index)}_tfp"
  package_filename           = "../input/${element(var.lambda_functions, count.index)}.zip"
  handler                    = "${element(var.lambda_functions, count.index)}.handler"
  runtime                    = "nodejs16.x"
  role                       = module.lambda_iam.lambda_execution_role_arn
  source_code                = data.archive_file.lambda_package[count.index].output_base64sha256
  depends_on                 = [module.lambda_iam]
}

################################################ IAM ###############################################
module "lambda_iam" {
  source                     = "../modules/lambda_iam"
  kinesis_stream_arn         = module.kinesis.kinesis_stream_arn
  dynamodb_arn               = module.dynamodb.dynamodb_arn
  depends_on                 = [module.kinesis,  module.dynamodb]
}

################################################ KINESIS ###############################################
module "kinesis" {
  source = "../modules/kinesis"
  name = "data-stream-tfp"
  shards = 1
  retention_period = 24
}

################################################ DYNAMODB ###############################################
module "dynamodb" {
  source          = "../modules/dynamodb"
  name            = "products-tfp"
  read_capacity   = 1
  write_capacity  = 1
  hash_key        = "productId"
}

################################################ TRIGGERS ###############################################
#  kinesis event to trigger lambda orders
module "lambda_trigger_kinesis_orders" {
  source = "../modules/lambda_trigger_kinesis"
  lambda_function_name = "manage_email_tfp"
  #module.lambda_function_email.lambda_function_name
  kinesis_stream       = module.kinesis.kinesis_stream_arn
  depends_on           = [module.kinesis, module.lambda_function]
}

#  kinesis event to trigger lambda shipping
module "lambda_trigger_kinesis_shipping" {
  source = "../modules/lambda_trigger_kinesis"
  lambda_function_name = "manage_shipping_tfp"
  #module.lambda_function_shipping.lambda_function_name
  kinesis_stream       = module.kinesis.kinesis_stream_arn
  depends_on           = [module.kinesis, module.lambda_function]
}

# permissions api gw to call lambda orders
module "lambda_trigger_apigw" {
  source = "../modules/lambda_trigger_apigw"
  lambda_function_name = "manage_orders_tfp"
  api_gw_execution_arn = module.api_gateway.api_gw_execution_arn
  depends_on           = [module.api_gateway]
}

# permissions api gw to call lambda orders
module "lambda_trigger_apigw_products" {
  source = "../modules/lambda_trigger_apigw"
  lambda_function_name = "manage_products_tfp"
  api_gw_execution_arn = module.api_gateway.api_gw_execution_arn
  depends_on           = [module.api_gateway]
}

################################################ SES ###############################################
module "ses" {
  source     = "../modules/ses"
  email      = "tamara.delgado@vista.com"
}
