resource "aws_codeartifact_domain" "example" {
  domain         = "spindrartifact"
}

resource "aws_codeartifact_repository" "test" {
  repository = "vprofile-maven-repo"
  description = "this repo is for storing artifact acquired after running mvn install"
  domain     = aws_codeartifact_domain.example.domain
  domain_owner = data.aws_caller_identity.current.account_id
  external_connections {
    external_connection_name = "public:maven-central"
  }
}
data "aws_caller_identity" "current" {}
data "aws_codeartifact_authorization_token" "test" {
  domain = aws_codeartifact_domain.example.domain
  duration_seconds = "7200"
}
data "aws_codeartifact_repository_endpoint" "test" {
  domain     = aws_codeartifact_domain.example.domain
  repository = aws_codeartifact_repository.test.repository
  format     = "maven"
}

output "certificate_token" {
  value = data.aws_codeartifact_authorization_token.test.authorization_token
}
output "expiration" {
  value = data.aws_codeartifact_authorization_token.test.expiration
}
output "cart_endpoint_url" {
  value = data.aws_codeartifact_repository_endpoint.test.repository_endpoint
}