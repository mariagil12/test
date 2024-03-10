output "api_gw_execution_arn" {
  value = aws_api_gateway_rest_api.inventory_api.execution_arn
}


output "invoke_url_product" {
  value = "${aws_api_gateway_deployment.deployment.invoke_url}"
}

# output "invoke_url_products" {
#   value = "${aws_api_gateway_deployment.deployment.invoke_url}/products"
# }
#
# output "invoke_url_order" {
#   value = "${aws_api_gateway_deployment.deployment.invoke_url}/order"
# }