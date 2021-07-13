locals {
  source_repository_url = "https://bitbucket.org/${var.source_repository}"
  repository_name       = split("/", var.source_repository)[1]
  pipeline_name         = "terraform-${local.repository_name}-${var.env_name}"
  artifacts_bucket_name = "s3-codepipeline-${local.pipeline_name}"
  codepipeline_name     = "codepipeline-${local.pipeline_name}"
  build_name            = "codebuild-${local.pipeline_name}"
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = local.artifacts_bucket_name
  acl           = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
  tags = tomap({
    UseWithCodeDeploy = true
    created_by        = "terraform"
  })
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "role-${local.codepipeline_name}"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role_policy.json
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "policy-${local.codepipeline_name}"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_role_policy.json
}

resource "aws_iam_role" "codebuild_role" {
  name               = "role-${local.build_name}"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
}

resource "aws_iam_role_policy" "cloudWatch_policy" {
  name   = "policy-cloudwatch-${local.pipeline_name}"
  role   = aws_iam_role.codebuild_role.id
  policy = data.aws_iam_policy_document.codebuild_role_policy.json
}
