FROM openjdk:11-jre-slim
WORKDIR /app
COPY target/myapp-1.0-SNAPSHOT.jar app.jar    #myapp-1.0-SNAPSHOT.jar is the generated JAR file from built in my target folder 
ENTRYPOINT ["java", "-jar", "app.jar"]
