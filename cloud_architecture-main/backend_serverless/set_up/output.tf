output "kinesis_stream_arn" {
  value = module.kinesis.kinesis_stream_arn
}

output "invoke_url_product" {
  value = "${module.api_gateway.invoke_url_product}/product"
}
output "invoke_url_products" {
  value = "${module.api_gateway.invoke_url_product}/products"
}
output "invoke_url_order" {
  value = "${module.api_gateway.invoke_url_product}/order"
}