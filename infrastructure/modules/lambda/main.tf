data "archive_file" "fn_zip" {
  type        = "zip"
  source_file = var.code_path
  output_path = "${var.code_path}.zip"
}

resource "aws_lambda_function" "fn" {
  function_name    = "${var.environment}-${var.function_name}"
  filename         = "${var.code_path}.zip"
  handler          = var.handler
  source_code_hash = "data.archive_file.zip.output_base64sha256"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "go1.x"
  memory_size      = 128
  timeout          = 10
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.environment}-${var.function_name}-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}