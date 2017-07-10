pipeline {
  agent {
    node {
      label 'ruby'
    }
    
  }
  stages {
    stage('Test') {
      steps {
        sh '''rbenv global 2.3.1
bundle install
bundle exec rubocop'''
      }
    }
  }
}