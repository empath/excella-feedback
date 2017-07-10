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
eval "$(rbenv init -)"
bundle install
bundle exec rubocop
bundle exec bin/rails test '''
      }
    }
  }
}