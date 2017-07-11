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
          sh '''aws cloudformation validate-template --template-body file://cf.yaml

if [ "$(aws cloudformation describe-stacks --query 'Stacks[?StackName==`prodexcellajt-vpc`]')" != '[]' ];
 then aws cloudformation create-stack --stack-name cicd-rails-app --template-body file://cf.yaml \
  --parameters ParameterKey=MasterUserName,ParameterValue=${dbusername} ParameterKey=MasterPassword,ParameterValue=${dbpassword}
else
  aws cloudformation update-stack --stack-name cicd-rails-app --template-body file://cf.yaml --parameters ParameterKey=MasterUserName,ParameterValue=${dbusername} ParameterKey=MasterPassword,ParameterValue=${dbpassword}
fi'''
        }
        
      }
    }
  }
}