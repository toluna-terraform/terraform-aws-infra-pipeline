# code_build spec for pulling source from BitBucket



version: 0.2

env:
  exported-variables:
    - CODEBUILD_WEBHOOK_TRIGGER
phases:
  install:
    runtime-versions:
      docker: 18
  build:
    commands:
      - echo Build started on `date`
artifacts:
  files:
    - '**/*'
  discard-paths: no
  name: source_artifacts.zip
