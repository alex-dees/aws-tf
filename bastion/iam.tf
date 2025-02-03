data "aws_iam_policy" "s3-full" {
  name = "AmazonS3FullAccess"
}

data "aws_iam_policy" "ssm-managed" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "bastion-role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
            Service = "ec2.amazonaws.com"
        }
    }]
  })
}

resource "aws_iam_role_policy_attachments_exclusive" "bastion-policies" {
  role_name = aws_iam_role.bastion-role.name
  policy_arns = [
    data.aws_iam_policy.s3-full.arn,
    data.aws_iam_policy.ssm-managed.arn
  ]
}