data "aws_caller_identity" "current" {}

resource "aws_iam_role" "readonly" {
  name = "platform-readonly"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { AWS = data.aws_caller_identity.current.arn }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "readonly" {
  role       = aws_iam_role.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

output "readonly_role_arn" {
  value = aws_iam_role.readonly.arn
}
