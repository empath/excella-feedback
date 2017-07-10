pipeline {
  agent {
    node {
      label 'ruby'
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