env
export APP_NAME=Java-App
export NEWRELIC_KEY=a844635132d2d9a07559401d9ac7261b62cdNRAL
export LOGS_FILE_LOCATION=logs.log
export TASK_META=`curl ${ECS_CONTAINER_METADATA_URI_V4}`
envsubst < /etc/td-agent/td-agent-template.conf > /etc/td-agent/td-agent.conf
cat /etc/td-agent/td-agent.conf
sudo systemctl start td-agent.service
java -jar target/mavenwebapp.jar 2>&1 | tee -a /logs.log