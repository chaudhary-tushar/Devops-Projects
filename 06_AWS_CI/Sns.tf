resource "aws_sns_topic" "user_updates" {
  name = "vpro-pipeline-notifications"
}

resource "aws_sns_topic_subscription" "Email" {
  topic_arn = aws_sns_topic.user_updates.arn
  protocol = "email"
  endpoint = var.User-email
}