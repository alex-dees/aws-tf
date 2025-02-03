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

resource "aws_iam_role_policy_attachment" "attach-ssm" {
  role = aws_iam_role.bastion-role.name
  policy_arn = data.aws_iam_policy.ssm-managed.arn
}