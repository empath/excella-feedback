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

        node(label: 'ruby') {
          checkout scm
          sh '''#!/usr/bin/env bash
eval "$(rbenv init -)"
gem install cfer
cfer converge -t cf.rb rails-test MasterUsername=${dbusername} MasterUserPassword=${dbpassword}
'''
        }

      }
    }
  }
}
