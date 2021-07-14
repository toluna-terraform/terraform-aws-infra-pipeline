resource "aws_codebuild_webhook" "name" {
  project_name = aws_codebuild_project.tf_source.name
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }
    filter {
      type    = "FILE_PATH"
      pattern = "terraform/.*"
    }

    filter {
      type    = "HEAD_REF"
      pattern = var.trigger_branch
    }
  }
}



resource "aws_codebuild_project" "tf_source" {
  name          = "${local.build_name}-source"
  description   = "Pull TF source files from Git repo"
  build_timeout = "120"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    packaging = "ZIP"
    type      = "S3"
    override_artifact_name = true
    location  = aws_s3_bucket.codepipeline_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/code_build/${local.build_name}/log-group"
      stream_name = "/code_build/${local.build_name}/stream"
    }
  }

  source {
    type     = "BITBUCKET"
    location = local.source_repository_url
    buildspec = templatefile("${path.module}/templates/buildspec-git-merge.yml.tpl", { ENV_VAR = "testing 124"})
  }
  tags = tomap({
    Name        = "codebuild-${local.build_name}",
    environment = var.env_name,
    created_by  = "terraform"
  })
}

resource "aws_codebuild_project" "tf_plan" {
  name          = "${local.build_name}-plan"
  description   = "Generate TF plan"
  build_timeout = "120"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    override_artifact_name = true
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/code_build/${local.build_name}/log-group"
      stream_name = "/code_build/${local.build_name}/stream"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = templatefile("${path.module}/templates/buildspec-tf-plan.yml.tpl", { ENV_VAR = "testing 124"})
  }
  tags = tomap({
    Name        = "codebuild-${local.build_name}",
    environment = var.env_name,
    created_by  = "terraform"
  })
}

