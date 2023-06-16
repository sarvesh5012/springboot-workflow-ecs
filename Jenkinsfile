pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="382904467012"
        AWS_DEFAULT_REGION="us-east-1"
        IMAGE_REPO_NAME="mavenregistry"
        IMAGE_TAG="${GIT_COMMIT}"
        CLUSTER_NAME = "MavenCluster"
        SERVICE_NAME = "test-service"
        TASKDEF_NAME = "tdf-maven"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        
    }
    

    stages {
        
    stage('Logging into AWS ECR') {
            steps {
                script {
                sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }
                 
            }
        }

    stage('Cloning Git') {
            steps {
                checkout scmGit(branches: [[name: '*/${branchName}']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/sarvesh5012/springboot-workflow-ecs.git']])
                sh "env"        
            }
        }
        
  
    // Building Docker images
    stage('Building image') {
      steps{
        script {
          sh "docker build -t ${IMAGE_REPO_NAME}:${IMAGE_TAG} ."
        }
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                sh "aws sts get-caller-identity"
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
         }
        }
      }
    
    stage('ECS Deployment'){
      steps{
        script{
          sh "aws ecs describe-task-definition --task-definition ${TASKDEF_NAME} > task-def.json"
          sh "jq .taskDefinition task-def.json > taskdefinition.json"
          sh "jq 'del(.taskDefinitionArn)' taskdefinition.json | jq 'del(.revision)' | jq 'del(.status)' | jq 'del(.requiresAttributes)' | jq 'del(.compatibilities)' | jq 'del(.registeredAt)'| jq 'del(.registeredBy)' > container-definition.json"
          sh "jq '.containerDefinitions[0].image = \"${REPOSITORY_URI}:${IMAGE_TAG}\"' container-definition.json > temp-taskdef.json"
          sh "ls"
          sh "cat temp-taskdef.json"
          sh "aws ecs register-task-definition --cli-input-json file://temp-taskdef.json"
          sh "aws ecs update-service --cluster  ${CLUSTER_NAME} --service  ${SERVICE_NAME} --task-definition  ${TASKDEF_NAME}"
        }
      }
    }

    }
}

























