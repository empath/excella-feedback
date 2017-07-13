pipeline {
  agent {
    node {
      label 'cloudformation'
    }

  }
  stages {
    stage('Lint') {
      steps {
        sh '''#!/usr/bin/env bash
        eval "$(rbenv init -)"
gem install rubocop
rubocop --fail-level E'''
      }
    }
    stage('Setup'){
      steps {
        checkout scm
        sh '''#!/usr/bin/env bash
eval "$(rbenv init -)"
gem install specific_install
gem specific_install https://github.com/empath/cfer.git'''
        node(label: 'awscli') {
          script {
            env['dbusername'] = sh(script: "aws ssm get-parameters --names RailsPg_user --with-decryption --region us-east-1 --query 'Parameters[0].Value' --output text", returnStdout: true).trim()
            env['dbpassword'] = sh(script: "aws ssm get-parameters --names railspg_password --with-decryption --region us-east-1 --query 'Parameters[0].Value' --output text", returnStdout: true).trim()
          }

        }
          sh '''#!/usr/bin/env bash
eval "$(rbenv init -)"
cfer converge --role-arn arn:aws:iam::061207487004:role/Rails-Deploy --region us-east-1 -t cf.rb cicd-rails-test MasterUsername=${dbusername} MasterUserPassword=${dbpassword}
status=$(cfer describe --region us-east-1 cicd-rails-test | grep Status | awk '{print $2}')
[ "$status" == "CREATE_COMPLETE" ] || [ "$status" == "UPDATE_COMPLETE" ]
'''
          script {
            env['dbendpointaddress'] = sh(script: "eval \"\$(rbenv init -)\"; cfer describe --region us-east-1 cicd-rails-test | grep DbEndpointAddress | awk '{print \$NF}'", returnStdout: true).trim()
            env['dbendpointport'] = sh(script: "eval \"\$(rbenv init -)\"; cfer describe --region us-east-1 cicd-rails-test | grep DbEndpointPort | awk '{print \$NF}'", returnStdout: true).trim()
          }
      }
    }
    stage ('Testing ') {
      steps {
      node(label: 'rails') {
        checkout scm
        sh '''#!/usr/bin/env bash
eval "$(rbenv init -)"
bundle install
echo $dbendpointaddress
echo $dbendpointport
export RAILS_ENV=test
rails db:create
rails db:migrate
rake test
'''
      }}

    }
  stage ('Tear Down Test, Update Production'){
    steps {
      parallel(
        tearDownTest: {
        checkout scm
        sh '''#!/usr/bin/env bash
eval "$(rbenv init -)"
cfer delete --region us-east-1 cicd-rails-test
'''
      },
      updateProd: {
        checkout scm
        sh '''#!/usr/bin/env bash
eval "$(rbenv init -)"
cfer converge --role-arn arn:aws:iam::061207487004:role/Rails-Deploy --region us-east-1 -t cf.rb cicd-rails-prod Environment=production DBInstanceType=db.m4.large MasterUsername=${dbusername} MasterUserPassword=${dbpassword}
status=$(cfer describe --region us-east-1 cicd-rails-prod | grep Status | awk '{print $2}')
[ "$status" == "CREATE_COMPLETE" ] || [ "$status" == "UPDATE_COMPLETE" ]
'''
      })
    }

  }
  }
}
