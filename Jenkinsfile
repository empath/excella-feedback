pipeline {
  agent {
    node {
      label 'ecs'
    }
    
  }
  stages {
    stage('lint') {
      steps {
        sh '''apt-get update
apt-get -y install ruby
gem install bundler
bundle install
rubocop'''
      }
    }
  }
}