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
      - echo ${PR_payload}
      - curl ${PR_payload}
      - curl ${PR_payload}/activity
      - export PR_HOOK="https://bitbucket.org/api/2.0/repositories/tolunaengineering/chorus/pullrequests/$CODEBUILD_WEBHOOK_TRIGGER"
      - curl $PR_HOOK
      - cd terraform/app
      - terraform init
      - terraform workspace select ${ENV_NAME}
      - terraform plan -out=tf.plan
artifacts:
  files:
    - 'terraform/app/tf.plan'
  discard-paths: yes
  name: tf.plan
