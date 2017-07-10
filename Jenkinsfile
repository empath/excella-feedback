pipeline {
  agent {
    node {
      label 'rails'
    }
    
  }
  stages {
    stage('Test') {
      steps {
        sh '''rbenv global 2.3.1
eval "$(rbenv init -)"
bundle install
bundle exec rubocop
bundle exec rails test '''
      }
    }
  }
}