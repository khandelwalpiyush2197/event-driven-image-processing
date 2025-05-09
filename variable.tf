variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "source_bucket_name" {
  description = "Name of the source S3 bucket"
  type        = string
}

variable "dest_bucket_name" {
  description = "Name of the destination S3 bucket"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_role_name" {
  description = "IAM role name for Lambda"
  type        = string
}

variable "lambda_policy_name" {
  description = "IAM policy name for Lambda"
  type        = string
}
