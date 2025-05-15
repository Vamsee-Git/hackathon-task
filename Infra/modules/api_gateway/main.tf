resource "aws_apigatewayv2_api" "users_api" {
  name          = "user_api"
  protocol_type = "HTTP"
  description   = "User management API"
}

# POST /users Route
resource "aws_apigatewayv2_route" "create_user_route" {
  api_id    = aws_apigatewayv2_api.users_api.id
  route_key = "POST /users"
  target    = "integrations/${aws_apigatewayv2_integration.user_integration.id}"
}

# GET /users Route
resource "aws_apigatewayv2_route" "get_user_route" {
  api_id    = aws_apigatewayv2_api.users_api.id
  route_key = "GET /users"
  target    = "integrations/${aws_apigatewayv2_integration.user_integration.id}"
}

# API Gateway Stage
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.users_api.id
  name        = "$default"
  auto_deploy = true
}

# API Gateway Integration
resource "aws_apigatewayv2_integration" "user_integration" {
  api_id             = aws_apigatewayv2_api.users_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.lambda_function_arn
  integration_method = "POST"
}

# Lambda Permission for API Gateway
resource "aws_lambda_permission" "apigw_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.users_api.execution_arn}/*/*"
}

variable "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  type        = string
}
variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}


