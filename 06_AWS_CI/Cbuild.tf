resource "aws_codebuild_project" "SonarAnalysis" {
  name = "vprofile-sona-analyz"
  description = "this build project is for doing sonar analysis"
  service_role = aws_iam_role.cbuildservicerole.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.coderepo.clone_url_http
    git_clone_depth = 0
    buildspec = file("sonarspec.yml")
  }
}

resource "aws_codebuild_project" "Vproartifact" {
  name = "vprofile-build-artifact"
  description = "this build project is for building artifact"
  service_role = aws_iam_role.cbuildservicerole.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.coderepo.clone_url_http
    git_clone_depth = 0
    buildspec = file("buildspec.yml")
  }

}