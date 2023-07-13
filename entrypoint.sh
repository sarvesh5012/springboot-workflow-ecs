sudo systemctl start td-agent.service
env
curl $ECS_CONTAINER_METADATA_URI
java -jar target/mavenwebapp.jar > /logs.log 2>&1