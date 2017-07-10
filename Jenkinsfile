pipeline {
  agent {
    node {
      label 'ecs'
    }
    
  }
  stages {
    stage('lint') {
      steps {
        sh '''bundle install
rubocop'''
      }
    }
  }
}