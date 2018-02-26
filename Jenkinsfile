pipeline {
  agent { 
    dockerfile {
          filename 'Dockerfile'
          args '--user root'
          reuseNode true 
    }
  }
  stages {
    stage('offline') {
      steps {
        script {
          try {
              githubNotify status: "PENDING", sha: "${GITHUB_PR_HEAD_SHA}", description: "Build started...", credentialsId: "ntcteam", account: "networktocode", repo: "cicd-testing"
              sh 'yamllint -d yamllint.yml .'
              sh 'ansible-playbook -i prod_inventory offline_data_checks.yml'
              sh 'ansible-playbook -i qa_inventory build_configs.yml'
          } catch(err) {
              githubNotify status: "FAILURE", sha: "${GITHUB_PR_HEAD_SHA}", description: "Build started...", credentialsId: "ntcteam", account: "networktocode", repo: "cicd-testing"
              currentBuild.result = 'FAILED'
              throw err
          }
        }
      }
    }
    stage('push_config') {
      steps {
        script {
          try {
              githubNotify status: "PENDING", sha: "${GITHUB_PR_HEAD_SHA}", description: "Build started...", credentialsId: "ntcteam", account: "networktocode", repo: "cicd-testing"
              sh 'ansible-playbook -i qa_inventory push_updated_config.yml'
          } catch(err) {
              githubNotify status: "FAILURE", sha: "${GITHUB_PR_HEAD_SHA}", description: "Build started...", credentialsId: "ntcteam", account: "networktocode", repo: "cicd-testing"
              currentBuild.result = 'FAILED'
              throw err
          }
        }
      }
    }
    stage('post_deploy_tests') {
      steps {
        script {
          try {
              githubNotify status: "PENDING", sha: "${GITHUB_PR_HEAD_SHA}", description: "Build started...", credentialsId: "ntcteam", account: "networktocode", repo: "cicd-testing"
              sh 'echo Post Deployment Tests'
          } catch(err) {
              githubNotify status: "FAILURE", sha: "${GITHUB_PR_HEAD_SHA}", description: "Build started...", credentialsId: "ntcteam", account: "networktocode", repo: "cicd-testing"
              currentBuild.result = 'FAILED'
              throw err
          } finally {
              sh "echo 'shell scripts to deploy to server...'"
              githubNotify status: "SUCCESS", sha: "${GITHUB_PR_HEAD_SHA}", description: "Build started...", credentialsId: "ntcteam", account: "networktocode", repo: "cicd-testing"
          }
        }
      }
    }
  }
}
