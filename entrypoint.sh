env
export APP_NAME=JavaApp
export NEWRELIC_KEY=a844635132d2d9a07559401d9ac7261b62cdNRAL
export LOGS_FILE_LOCATION=logs
envsubst < /etc/td-agent/td-agent-template.conf > /etc/td-agent/td-agent.conf
cat /etc/td-agent/td-agent.conf
sudo systemctl start td-agent.service
export CLUSTER_ARN=`curl ${ECS_CONTAINER_METADATA_URI_V4} | jq '.Labels."com.amazonaws.ecs.cluster"'`
java -jar target/mavenwebapp.jar > /logs.log 2>&1