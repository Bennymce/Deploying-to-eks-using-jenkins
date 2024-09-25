# Use OpenJDK 11 JRE as the base image
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the JAR file from the target directory
COPY target/simple-java-app-1.0-SNAPSHOT.jar app.jar

# Expose the application on port 8080
EXPOSE 8080

# Command to run the JAR file
ENTRYPOINT ["java", "-jar", "app.jar"]
