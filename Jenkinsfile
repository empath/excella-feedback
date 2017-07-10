pipeline {
  agent {
    node {
      label 'ruby'
    }
    
  }
  stages {
    stage('Configure Ruby') {
      steps {
        sh '''rbenv install 2.3.1
rbenv global 2.3.1
ruby -v
'''
      }
    }
    stage('Test') {
      steps {
        sh '''bundle install
bundle exec rubocop'''
      }
    }
  }
}