resource "aws_codepipeline" "Codeline" {
  name = "vprofile-CI-pipeline"
  role_arn = aws_iam_role.cbuildservicerole.arn
  
  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
    }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      output_artifacts = ["source_output"]
      
      version          = "1"

      configuration = {
        PollForSourceChanges = "false"
        FullRepositoryId = aws_codecommit_repository.coderepo.repository_name
        BranchName       = "main"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
      }
    }
  }

  stage {
    name = "sonalysis"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.SonarAnalysis.name
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.Vproartifact.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        BucketName = aws_s3_bucket.codepipeline_bucket.bucket
        Extract = "true"
        ObjectKey = aws_s3_object.object.key
      }
    }
  }
  
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "test-bucket"
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.codepipeline_bucket.bucket
  key    = "Vpro-Artifact-store/"
}