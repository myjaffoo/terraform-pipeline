data "aws_iam_policy_document" "tf_policy_document" {
  statement {
    actions = [
      "s3:List*",
    ]

    resources = [
      "${formatlist("arn:aws:s3:::%s",var.bucket_name)}",
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
    ]

    resources = [
      "${formatlist("arn:aws:s3:::%s/*",var.bucket_name)}",
    ]
  }
}

resource "aws_iam_role" "tf_iam_role" {
  name = "tf-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${var.account}:root"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "tf_iam_policy" {
  name = "tf-iam-policy"
  role = "${aws_iam_role.tf_iam_role.name}"

  policy = "${data.aws_iam_policy_document.tf_policy_document.json}"
}
