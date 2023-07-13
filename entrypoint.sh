sudo systemctl start td-agent.service
java -jar target/mavenwebapp.jar > /logs.log 2>&1 