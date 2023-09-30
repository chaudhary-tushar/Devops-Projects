resource "aws_ssm_parameter" "certificate_token" {
  name  = "CODEARTIFACT_AUTH_TOKEN"
  type  = "SecureString"
  value = data.aws_codeartifact_authorization_token.test.authorization_token
}

resource "aws_ssm_parameter" "org" {
  name  = "Organization"
  type  = "String"
  value = var.organization
}

resource "aws_ssm_parameter" "host" {
  name  = "HOST"
  type  = "String"
  value = var.HOST
}

resource "aws_ssm_parameter" "repo-name" {
  name  = "Project"
  type  = "String"
  value = var.Project
}

resource "aws_ssm_parameter" "sonar-token" {
  name  = "sonartoken"
  type  = "SecureString"
  value = var.sonarcloudtoken
}

resource "aws_ssm_parameter" "cartifact-url" {
  name = "CART-ENDPOINT"
  type = "String"
  value = data.aws_codeartifact_repository_endpoint.test.repository_endpoint
}