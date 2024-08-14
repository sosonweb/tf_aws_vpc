provider "aws" {
  region = "us-east-1" # Adjust the region as needed
}

resource "aws_kms_key" "new_key" {
  count = var.changed_key != null ? 1 : 0

  description = "KMS key for S3 bucket encryption"
  key_usage   = "ENCRYPT_DECRYPT"
}

resource "aws_kms_key_policy" "new_key_policy" {
  count = var.changed_key != null ? 1 : 0

  key_id = aws_kms_key.new_key[0].id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
      {
        "Sid": "Enable IAM User Permissions",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action": "kms:*",
        "Resource": "*"
      },
      {
        "Sid": "Allow use of the key",
        "Effect": "Allow",
        "Principal": {
          "AWS": "${aws_iam_role.s3_kms_role.arn}"
        },
        "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_iam_role" "s3_kms_role" {
  name = "s3-kms-access-role"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"] # Adjust based on the service that will assume the role
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "s3_read_policy" {
  name        = "s3-read-access-policy"
  description = "Policy to allow read access to S3 bucket"

  policy = data.aws_iam_policy_document.s3_read_policy.json
}

data "aws_iam_policy_document" "s3_read_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "kms_decrypt_policy" {
  name        = "kms-decrypt-access-policy"
  description = "Policy to allow decrypt access using KMS key"

  policy = data.aws_iam_policy_document.kms_decrypt_policy.json
}

data "aws_iam_policy_document" "kms_decrypt_policy" {
  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt"
    ]

    resources = local.all_kms_keys
  }
}

resource "aws_iam_role_policy_attachment" "s3_read_attach" {
  policy_arn = aws_iam_policy.s3_read_policy.arn
  role       = aws_iam_role.s3_kms_role.name
}

resource "aws_iam_role_policy_attachment" "kms_decrypt_attach" {
  policy_arn = aws_iam_policy.kms_decrypt_policy.arn
  role       = aws_iam_role.s3_kms_role.name
}

locals {
  all_kms_keys = var.changed_key != null ? concat(var.kms_keys, [aws_kms_key.new_key[0].arn]) : var.kms_keys
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = var.acl

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = element(local.all_kms_keys, length(local.all_kms_keys) - 1) # Use the most recent key
      }
    }
  }

  tags = var.tags
}

output "updated_kms_keys" {
  value = local.all_kms_keys
}

data "aws_caller_identity" "current" {}
