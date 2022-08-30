module "api_gateway" {
  source      = "../../modules/api_gateway"
  environment = "local"
  api_name    = "example-api"
}

module "service1" {
  source        = "../../modules/lambda"
  code_path     = "../../../source/hello/hello"
  function_name = "service-1"
  environment   = "local"
  handler       = "hello"
}

module "api_gateway_route_1" {
  source = "../../modules/api_gateway_lambda_route"

  api_config = {
    id            = module.api_gateway.api_gw.id
    execution_arn = module.api_gateway.api_gw.execution_arn
  }

  routes = [
    {
      function_name      = "service-1"
      integration_method = "GET"
      integration_type   = "AWS_PROXY"
      integration_uri    = module.service1.fn.invoke_arn
      route              = "/hello"
    }
  ]
}

module "service2" {
  source        = "../../modules/lambda"
  code_path     = "../../../source/goodbye/goodbye"
  function_name = "service-2"
  environment   = "local"
  handler       = "goodbye"
}

module "api_gateway_route_2" {
  source = "../../modules/api_gateway_lambda_route"

  api_config = {
    id            = module.api_gateway.api_gw.id
    execution_arn = module.api_gateway.api_gw.execution_arn
  }

  routes = [
    {
      function_name      = "service-2"
      integration_method = "GET"
      integration_type   = "AWS_PROXY"
      integration_uri    = module.service2.fn.invoke_arn
      route              = "/goodbye"
    }
  ]
}