pipeline {
  agent {
    node {
      label 'ruby'
    }
    
  }
  stages {
    stage('Configure Ruby') {
      steps {
        sh '''git clone https://github.com/rbenv/rbenv.git ~/.rbenv
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"
rbenv install 2.3.1
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