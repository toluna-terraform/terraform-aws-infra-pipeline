# code_build spec for pulling source from BitBucket



version: 0.2

phases:
  install:
    commands:
      - yum install -y yum-utils
      - yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
      - yum -y install terraform
  build:
    commands:
      - echo Build started on `date`
      - cd terraform/app
      - mv $CODEBUILD_SRC_DIR_build_output/plan.out .
      - terraform init
      - terraform workspace select ${ENV_NAME}
      - terraform apply -auto-approve plan.out
