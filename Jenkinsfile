pipeline {
  agent {
    node {
      label 'ruby'
    }
    
  }
  stages {
    stage('Test') {
      steps {
        sh '''ruby -v
rbenv global 2.3.1
ruby -v
eval "$(rbenv init -)"
ruby -v
bundle install
bundle exec rubocop'''
      }
    }
  }
}