########################################
# SNS Topic
########################################

resource "aws_sns_topic" "alerts" {

  name = "three-tier-alerts"
}

########################################
# Email Subscription
########################################

resource "aws_sns_topic_subscription" "email" {

  topic_arn = aws_sns_topic.alerts.arn

  protocol = "email"

  endpoint = "YOUR_EMAIL@gmail.com"
}
