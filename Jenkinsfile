node {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }
   
    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("daanbuis12/buildserver")
    }
    stage('Launch, Test, and Remove Container'){
   
        sh 'docker container run --detach --publish 8080 --name nodes_application daanbuis12/buildserver:latest'
        sh 'docker ps'
        sh 'docker rm --force nodes_application'
        sh 'docker ps'
    }
    

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
 
    
    sshagent(credentials:["d50484ad-c382-4f63-807d-5ad4164392aa"]) {
        
        sh 'ssh ubuntu@3.91.35.217 "kubectl set image deployments/node-application node-application=daanbuis12/buildserver:latest"'
}
}
