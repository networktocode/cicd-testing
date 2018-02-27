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
              sh '''
                if [ "${GITHUB_PR_STATE}" == "CLOSED" ]; then export inventory="prod_inventory" ; else export inventory="qa_inventory" ; fi
                printenv
                yamllint -d yamllint.yml .
                ansible-playbook -i prod_inventory offline_data_checks.yml
                ansible-playbook -i ${inventory} build_configurations.yml
              '''
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
              sh '''
                if [ "${GITHUB_PR_STATE}" == "CLOSED" ]; then export inventory="prod_inventory" ; else export inventory="qa_inventory" ; fi
                ansible-playbook -i ${inventory} push_updated_config.yml
              '''
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
              sh '''
                if [ "${GITHUB_PR_STATE}" == "CLOSED" ]; then export inventory="prod_inventory" ; else export inventory="qa_inventory" ; fi
                ansible-playbook -i ${inventory} operational_checks.yml
              '''
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
