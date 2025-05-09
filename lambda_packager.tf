resource "null_resource" "build_lambda" {
  provisioner "local-exec" {
    command = <<EOT
      pip install -r lambda/requirements.txt -t lambda/
      cd lambda && zip -r ../lambda.zip .
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
