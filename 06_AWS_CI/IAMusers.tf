resource "aws_iam_user" "Ccommit-user" {
  name = "Ccommituser"
  force_destroy = true
}

resource "aws_iam_user_ssh_key" "user" {
  username   = aws_iam_user.Ccommit-user.name
  encoding   = "SSH"
  public_key = file("repokey.pub")
}

resource "aws_iam_user_policy" "ccomit-policy" {
  name = "Ccommit-policy"
  user = aws_iam_user.Ccommit-user.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["*",]
        Resource = "arn:aws:codecommit:us-east2::*"
      },
      {
        Effect   = "Allow",
        Action   = "codecommit:GetObject",
        Resource = "arn:aws:codecommit:us-east2::*"
      },
    ],
  })
  depends_on = [ aws_codecommit_repository.coderepo ]
}

resource "aws_iam_role" "cbuildservicerole" {
  name = "codebuildter01-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to the CodeBuild role as needed
resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.cbuildservicerole.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


output "ssh-user" {
  value = aws_iam_user_ssh_key.user.ssh_public_key_id
}