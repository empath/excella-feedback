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
          sh '''aws cloudformation validate-template --region us-east-1 --template-body file://cf.yaml

if [ "$(aws cloudformation describe-stacks --region us-east-1 --query 'Stacks[?StackName==`cicd-rails-app`]')" == '[]' ];
 then aws cloudformation create-stack \
 --region us-east-1 --stack-name cicd-rails-app \
--template-body file://cf.yaml   \
--role-arn arn:aws:iam::061207487004:role/Rails-Deploy \
--parameters ParameterKey=MasterUserName,ParameterValue=${dbusername} \
ParameterKey=MasterPassword,ParameterValue=${dbpassword} \
else
  aws cloudformation update-stack \
--region us-east-1 --stack-name cicd-rails-app \
--template-body file://cf.yaml \
--role-arn arn:aws:iam::061207487004:role/Rails-Deploy \
--parameters ParameterKey=MasterUserName,ParameterValue=${dbusername} \
ParameterKey=MasterPassword,ParameterValue=${dbpassword} \
fi

'''
        }
        
      }
    }
  }
}
