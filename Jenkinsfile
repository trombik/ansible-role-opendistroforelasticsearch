node ('virtualbox') {

  def directory = "ansible-role-opendistroforelasticsearch"
  env.ANSIBLE_VAULT_PASSWORD_FILE = "~/.ansible_vault_key"
  stage 'Clean up'
  deleteDir()

  stage 'Checkout'
  sh "mkdir $directory"
  dir("$directory") {
    try {
        checkout scm
        sh "git submodule update --init"
    } catch (e) {
        currentBuild.result = 'FAILURE'
        notifyBuild(currentBuild.result)
        throw e
    }
  }
  dir("$directory") {
    stage 'bundle'
    try {
        sh "bundle install --path ${env.JENKINS_HOME}/vendor/bundle"
    } catch (e) {
        currentBuild.result = 'FAILURE'
        notifyBuild(currentBuild.result)
        throw e
    }

    stage 'bundle exec kitchen test'
    try {
      sh 'bundle exec kitchen test'
    } catch (e) {
        currentBuild.result = 'FAILURE'
        notifyBuild(currentBuild.result)
        throw e
    } finally {
      sh 'bundle exec kitchen destroy'
    }
/* if you have integration tests, uncomment the stage below
    stage 'integration'
    try {
      // use native rake instead of bundle exec rake
      // https://github.com/docker-library/ruby/issues/73
      sh 'rake test'
    } catch (e) {
        currentBuild.result = 'FAILURE'
        notifyBuild(currentBuild.result)
        throw e
    } finally {
      sh 'rake clean'
    }
*/
    stage 'Notify'
    notifyBuild(currentBuild.result)
    step([$class: 'GitHubCommitNotifier', resultOnFailure: 'FAILURE'])
  }
}

def notifyBuild(String buildStatus = 'STARTED') {
  // build status of null means successful
  buildStatus =  buildStatus ?: 'SUCCESSFUL'

  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} build #${env.BUILD_NUMBER}'"
  def summary = "${subject} <a href='${env.BUILD_URL}'>${env.BUILD_URL}</a>"
  def details = """<p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
    <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>"""

  // Override default values based on build status
  if (buildStatus == 'STARTED') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'SUCCESSFUL') {
    color = 'GREEN'
    colorCode = '#00FF00'
  } else {
    color = 'RED'
    colorCode = '#FF0000'
  }

  hipchatSend (color: color, notify: true, message: summary)
}
/* vim: ft=groovy */
