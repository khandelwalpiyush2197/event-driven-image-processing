resource "null_resource" "build_lambda" {
  provisioner "local-exec" {
    command = "zip -r lambda.zip lambda_function.py"
  }

  triggers = {
    build_id = timestamp()
  }
}

resource "aws_lambda_function" "image_processor" {
  filename         = "${path.module}/lambda.zip"
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  environment {
    variables = {
      DEST_BUCKET = var.dest_bucket_name
    }
  }

  depends_on = [null_resource.build_lambda]
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source.arn
}

# --- S3 Trigger ---

resource "aws_s3_bucket_notification" "notify_lambda" {
  bucket = aws_s3_bucket.source.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}