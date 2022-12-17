node {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }
   
    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        dockerImage = docker.build("daanbuis12/buildserver:latest")
    }
    stage('Launch, Test, and Remove Container'){
   
        sh 'ssh ubuntu@184.73.13.241 docker container run --detach --publish 8080 --name node-application daanbuis12/buildserver:latest'
        sh 'ssh ubuntu@184.73.13.241docker ps'
        sh 'ssh ubuntu@184.73.13.241 docker rm --force node-application'
        
    }
    

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Pushing multiple tags is cheap, as all the layers are reused. */
         docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            dockerImage.push("${env.BUILD_NUMBER}")
            dockerImage.push("latest")
        }

      
        
    }
 
    
    sshagent(credentials:["d50484ad-c382-4f63-807d-5ad4164392aa"]) {
      
        sh 'ssh ubuntu@184.73.13.241 kubectl set image deployments/node-application buildserver=daanbuis12/buildserver:latest'
        sh 'ssh ubuntu@184.73.13.241 curl $(minikube ip):32408'
}
}
