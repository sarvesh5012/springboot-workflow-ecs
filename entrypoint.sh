sudo systemctl start td-agent.service
env
java -jar target/mavenwebapp.jar > /logs.log 2>&1