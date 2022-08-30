variable "api_config" {
  type = object({
    id            = string
    execution_arn = string
  })
}

variable "routes" {
  type = list(object({
    integration_uri    = string # required
    integration_type   = string # AWS_PROXY
    integration_method = string # GET
    route              = string # validate it's an arn
    function_name      = string # required
  }))
}