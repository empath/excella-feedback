pipeline {
  agent {
    node {
      label 'rails'
    }

  }
  stages {
    stage('Test') {
      steps {
        sh '''#rbenv global 2.3.1
#eval "$(rbenv init -)"
#bundle install
#bundle exec rubocop
#bundle exec rails test '''
        node(label: 'awscli') {
          script {
            env['dbusername'] = sh(script: "aws ssm get-parameters --names RailsPg_user --with-decryption --region us-east-1 --query 'Parameters[0].Value' --output text", returnStdout: true).trim()
            env['dbpassword'] = sh(script: "aws ssm get-parameters --names railspg_password --with-decryption --region us-east-1 --query 'Parameters[0].Value' --output text", returnStdout: true).trim()
          }

        }

        node(label: 'cloudformation') {
          checkout scm
          sh '''#!/usr/bin/env bash
eval "$(rbenv init -)"
gem install specific_install
gem specific_install git@github.com:empath/cfer.git
cfer converge --role_arn arn:aws:iam::061207487004:role/Rails-Deploy --region us-east-1 -t cf.rb cicd-rails-test MasterUsername=${dbusername} MasterUserPassword=${dbpassword}
'''
        }

      }
    }
  }
}
