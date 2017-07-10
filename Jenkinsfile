pipeline {
  agent {
    node {
      label 'ecs'
    }
    
  }
  stages {
    stage('lint') {
      steps {
        sh '''sudo apt-get update
sudo apt-get -y install ruby
gem install bundler
bundle install
rubocop'''
      }
    }
  }
}