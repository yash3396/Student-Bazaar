# Use Eclipse Temurin (OpenJDK) 8 as base image (actively maintained)
FROM eclipse-temurin:8-jdk

# Set working directory
WORKDIR /app

# Install Maven
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src
COPY web ./web

# Build the WAR file and copy dependencies
RUN mvn clean package -DskipTests && \
    mvn dependency:copy-dependencies -DoutputDirectory=target/lib

# Expose port (Railway will set PORT environment variable)
EXPOSE 8080

# Run the application using Jetty launcher JAR
# Railway will provide PORT environment variable
CMD ["java", "-jar", "target/Student_Bazar-launcher.jar"]

