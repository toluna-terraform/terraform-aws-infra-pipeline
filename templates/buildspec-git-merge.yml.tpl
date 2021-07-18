# code_build spec for pulling source from BitBucket



version: 0.2

phases:
  install:
    runtime-versions:
      docker: 18
  build:
    commands:
      - echo Build started on `date`
      - echo $CODEBUILD_WEBHOOK_TRIGGER
      - echo "PR_NUM=$(echo $CODEBUILD_WEBHOOK_TRIGGER | cut -d'/' -f2)"  > env_vars.props
artifacts:
  files:
    - '**/*'
  discard-paths: no
  name: source_artifacts.zip
