resource "aws_codecommit_repository" "coderepo" {
  repository_name = "Vprofile-code-repo"
  description     = "This repository host files of java app or ci-aws"
}
output "Ccommit-ssh-url" {
  value = aws_codecommit_repository.coderepo.clone_url_ssh
}