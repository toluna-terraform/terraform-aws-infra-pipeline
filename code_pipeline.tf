resource "aws_codepipeline" "codepipeline" {
  name     = local.codepipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Download_Merged_Sources"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        S3Bucket = aws_s3_bucket.codepipeline_bucket.bucket
        S3ObjectKey = "source_artifacts.zip"
        PollForSourceChanges = true
        
      }
    }
  }

  stage {
    name = "Plan"
    action {
      name             = "TF_Plan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.tf_plan.name
      }
    }

    action {
      name = "Approve_Plan"
      category = "Approval"
      owner = "AWS"
      provider = "Manual"
      version = 1
    }
  }

  stage {
    name = "Apply"
    action {
      name             = "TF_Apply"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["build_output","source_output"]
      configuration = {
        ProjectName = aws_codebuild_project.tf_apply.name
        PrimarySource = "source_output"
      }
    }
  }

}


