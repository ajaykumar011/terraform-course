# Archive a single file.
locals {
    lambda-zip-location = "outputs/welcome.zip"
}

data "archive_file" "init" {
  type        = "zip"
  source_file = "welcome.py"
  output_path = "${local.lambda-zip-location}"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = local.lambda-zip-location
  function_name = "welcome"
  role          = aws_iam_role.lambda_role.arn
  handler       = "welcome.hello"  
  #pythonfile.function in above example.
  description = "Simple Welcome program" 
  memory_size = 256 #default is 128MB can't set below 128
  timeout = 5 #default time is also 3 seconds
 
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  #coment the below line for the first time. uncomment if you want to change codes and deploy again. 
  source_code_hash = filebase64sha256(local.lambda-zip-location)

  runtime = "python3.7"

#  environment {
#    variables = {
#      foo = "bar"
#    }
  
  }