# code_build spec for pulling source from BitBucket



version: 0.2

phases:
  install:
    runtime-versions:
      docker: 18
  build:
    commands:
      - echo Build started on `date`
      - ls -l
artifacts:
  files:
    - '**/*'
  discard-paths: no
  name: tf.plan
