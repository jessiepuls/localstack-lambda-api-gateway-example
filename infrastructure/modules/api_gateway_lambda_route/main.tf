resource "aws_apigatewayv2_integration" "integration" {
  for_each           = { for r in var.routes : r.route => r }
  api_id             = var.api_config.id
  integration_uri    = each.value.integration_uri
  integration_type   = each.value.integration_type
  integration_method = each.value.integration_method
}

resource "aws_apigatewayv2_route" "route" {
  for_each  = { for r in var.routes : r.route => r }
  api_id    = var.api_config.id
  route_key = "each.value.integration_method each.value.route"
  target    = "integrations/${aws_apigatewayv2_integration.integration[each.key].id}"
}

resource "aws_lambda_permission" "invoke_access" {
  for_each      = { for r in var.routes : r.route => r }
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_config.execution_arn}/*/*"
}